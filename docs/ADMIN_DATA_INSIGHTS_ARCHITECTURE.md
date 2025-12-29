# Admin Data Insights Architecture

## Overview

This document defines the architecture for the Admin Data Insights system in FFL Playoffs. The system provides comprehensive analytics, reporting, and dashboard visualization capabilities for administrators to gain actionable insights into platform usage, user behavior, league performance, and business metrics.

## Business Context

### Problem Statement
Administrators need data-driven insights to:
- **Understand Platform Health**: Monitor key performance indicators and system metrics
- **Track User Engagement**: Analyze user behavior patterns and retention
- **Measure Business Growth**: Track league creation, user acquisition, and revenue
- **Identify Trends**: Discover patterns in player performance and league activity
- **Make Informed Decisions**: Support strategic decisions with data

### Success Criteria
- Real-time dashboards with sub-second refresh
- Historical trend analysis with customizable date ranges
- Exportable reports in multiple formats
- Configurable metrics and dimensions
- Drill-down capabilities for detailed analysis
- Scheduled report delivery

## Use Cases

### UC-1: View Executive Dashboard
**Actor**: Super Admin, Operations Manager
**Trigger**: Access insights dashboard
**Flow**:
1. Admin navigates to insights dashboard
2. System displays key performance indicators (KPIs)
3. Dashboard shows real-time metrics and trends
4. Admin can filter by date range or segment

### UC-2: Analyze User Engagement
**Actor**: Product Manager, Growth Team
**Trigger**: User behavior analysis need
**Flow**:
1. Admin selects user engagement report
2. System displays engagement metrics (DAU, WAU, MAU)
3. Admin views cohort retention analysis
4. Admin drills down into specific user segments

### UC-3: Generate Custom Report
**Actor**: Any Admin with reporting access
**Trigger**: Ad-hoc reporting need
**Flow**:
1. Admin opens report builder
2. Admin selects metrics and dimensions
3. Admin applies filters and date range
4. System generates and displays report
5. Admin exports or saves report

### UC-4: Schedule Recurring Report
**Actor**: Operations Manager
**Trigger**: Regular reporting requirement
**Flow**:
1. Admin creates or opens existing report
2. Admin configures schedule (daily, weekly, monthly)
3. Admin specifies recipients
4. System delivers reports on schedule

### UC-5: Monitor League Performance
**Actor**: League Operations, Customer Success
**Trigger**: League health monitoring
**Flow**:
1. Admin selects league analytics
2. System displays league performance metrics
3. Admin views draft participation, trade activity
4. Admin identifies underperforming or at-risk leagues

### UC-6: Analyze Draft Trends
**Actor**: Product Team, Content Team
**Trigger**: Draft feature optimization
**Flow**:
1. Admin opens draft analytics
2. System shows draft completion rates, timing patterns
3. Admin views player selection trends
4. Admin identifies popular strategies

## Domain Model

### Aggregates

#### AnalyticsQuery Aggregate (Root)
```java
public class AnalyticsQuery {
    private QueryId id;
    private String name;
    private String description;
    private QueryDefinition definition;
    private AdminId createdBy;
    private Instant createdAt;
    private Instant lastExecutedAt;
    private QueryExecutionStats executionStats;
    private boolean isTemplate;
    private boolean isPublic;
    private List<QueryTag> tags;

    public static AnalyticsQuery create(
            String name,
            QueryDefinition definition,
            AdminId createdBy) {
        return AnalyticsQuery.builder()
            .id(QueryId.generate())
            .name(name)
            .definition(definition)
            .createdBy(createdBy)
            .createdAt(Instant.now())
            .isTemplate(false)
            .isPublic(false)
            .tags(new ArrayList<>())
            .build();
    }

    public QueryResult execute(AnalyticsEngine engine) {
        Instant start = Instant.now();
        QueryResult result = engine.execute(definition);
        updateExecutionStats(start);
        return result;
    }

    public void markAsTemplate() {
        this.isTemplate = true;
    }

    public void makePublic() {
        this.isPublic = true;
    }

    public AnalyticsQuery cloneForUser(AdminId newOwner) {
        return AnalyticsQuery.builder()
            .id(QueryId.generate())
            .name(this.name + " (Copy)")
            .definition(this.definition.copy())
            .createdBy(newOwner)
            .createdAt(Instant.now())
            .isTemplate(false)
            .isPublic(false)
            .tags(new ArrayList<>(this.tags))
            .build();
    }

    private void updateExecutionStats(Instant start) {
        this.lastExecutedAt = Instant.now();
        long durationMs = Duration.between(start, lastExecutedAt).toMillis();
        if (executionStats == null) {
            executionStats = new QueryExecutionStats();
        }
        executionStats.recordExecution(durationMs);
    }
}
```

#### Report Aggregate
```java
public class Report {
    private ReportId id;
    private String name;
    private String description;
    private ReportType type;
    private ReportLayout layout;
    private List<ReportSection> sections;
    private ReportFilters defaultFilters;
    private AdminId createdBy;
    private Instant createdAt;
    private Instant updatedAt;
    private ReportSchedule schedule;
    private List<ReportRecipient> recipients;
    private ExportConfiguration exportConfig;

    public static Report create(
            String name,
            ReportType type,
            AdminId createdBy) {
        return Report.builder()
            .id(ReportId.generate())
            .name(name)
            .type(type)
            .layout(ReportLayout.defaultLayout())
            .sections(new ArrayList<>())
            .defaultFilters(ReportFilters.empty())
            .createdBy(createdBy)
            .createdAt(Instant.now())
            .updatedAt(Instant.now())
            .build();
    }

    public void addSection(ReportSection section) {
        sections.add(section);
        section.setOrder(sections.size());
        this.updatedAt = Instant.now();
    }

    public void removeSection(SectionId sectionId) {
        sections.removeIf(s -> s.getId().equals(sectionId));
        reorderSections();
        this.updatedAt = Instant.now();
    }

    public void reorderSections(List<SectionId> newOrder) {
        Map<SectionId, ReportSection> sectionMap = sections.stream()
            .collect(Collectors.toMap(ReportSection::getId, s -> s));

        sections.clear();
        for (int i = 0; i < newOrder.size(); i++) {
            ReportSection section = sectionMap.get(newOrder.get(i));
            if (section != null) {
                section.setOrder(i + 1);
                sections.add(section);
            }
        }
        this.updatedAt = Instant.now();
    }

    public void setSchedule(ReportSchedule schedule) {
        this.schedule = schedule;
        this.updatedAt = Instant.now();
    }

    public void addRecipient(ReportRecipient recipient) {
        recipients.add(recipient);
    }

    public ReportSnapshot generate(ReportGenerator generator, ReportFilters filters) {
        ReportFilters effectiveFilters = filters != null ?
            filters.mergeWith(defaultFilters) : defaultFilters;
        return generator.generate(this, effectiveFilters);
    }

    public boolean isDueForScheduledRun(Instant now) {
        return schedule != null && schedule.isDue(now);
    }
}
```

#### Dashboard Aggregate
```java
public class Dashboard {
    private DashboardId id;
    private String name;
    private String description;
    private DashboardType type;
    private List<DashboardWidget> widgets;
    private DashboardLayout layout;
    private RefreshInterval refreshInterval;
    private DateRange defaultDateRange;
    private List<DashboardFilter> globalFilters;
    private AdminId ownerId;
    private boolean isDefault;
    private boolean isPublic;
    private Instant createdAt;
    private Instant updatedAt;

    public static Dashboard createDefault(DashboardType type) {
        Dashboard dashboard = Dashboard.builder()
            .id(DashboardId.generate())
            .name(type.getDefaultName())
            .type(type)
            .widgets(new ArrayList<>())
            .layout(DashboardLayout.grid(12))
            .refreshInterval(RefreshInterval.FIVE_MINUTES)
            .defaultDateRange(DateRange.last30Days())
            .globalFilters(new ArrayList<>())
            .isDefault(true)
            .isPublic(true)
            .createdAt(Instant.now())
            .updatedAt(Instant.now())
            .build();

        // Add default widgets based on type
        dashboard.addDefaultWidgets(type);
        return dashboard;
    }

    public void addWidget(DashboardWidget widget) {
        widget.setPosition(findNextAvailablePosition());
        widgets.add(widget);
        this.updatedAt = Instant.now();
    }

    public void removeWidget(WidgetId widgetId) {
        widgets.removeIf(w -> w.getId().equals(widgetId));
        this.updatedAt = Instant.now();
    }

    public void updateWidgetPosition(WidgetId widgetId, WidgetPosition newPosition) {
        widgets.stream()
            .filter(w -> w.getId().equals(widgetId))
            .findFirst()
            .ifPresent(w -> w.setPosition(newPosition));
        this.updatedAt = Instant.now();
    }

    public void updateWidgetConfig(WidgetId widgetId, WidgetConfiguration config) {
        widgets.stream()
            .filter(w -> w.getId().equals(widgetId))
            .findFirst()
            .ifPresent(w -> w.updateConfiguration(config));
        this.updatedAt = Instant.now();
    }

    public DashboardSnapshot render(DashboardRenderer renderer, DateRange dateRange) {
        DateRange effectiveRange = dateRange != null ? dateRange : defaultDateRange;
        return renderer.render(this, effectiveRange, globalFilters);
    }

    private void addDefaultWidgets(DashboardType type) {
        List<DashboardWidget> defaultWidgets = DashboardWidgetFactory.createDefaults(type);
        for (DashboardWidget widget : defaultWidgets) {
            addWidget(widget);
        }
    }

    private WidgetPosition findNextAvailablePosition() {
        // Find next available grid position
        int maxY = widgets.stream()
            .mapToInt(w -> w.getPosition().getY() + w.getPosition().getHeight())
            .max()
            .orElse(0);
        return new WidgetPosition(0, maxY, 6, 4);
    }
}
```

#### Metric Aggregate
```java
public class Metric {
    private MetricId id;
    private String name;
    private String displayName;
    private String description;
    private MetricType type;
    private MetricCategory category;
    private MetricCalculation calculation;
    private MetricFormat format;
    private List<MetricDimension> supportedDimensions;
    private List<MetricFilter> supportedFilters;
    private AggregationType defaultAggregation;
    private boolean isCalculated;
    private boolean isRealTime;
    private DataSource dataSource;

    public static Metric define(
            String name,
            MetricType type,
            MetricCalculation calculation) {
        return Metric.builder()
            .id(MetricId.generate())
            .name(name)
            .displayName(toDisplayName(name))
            .type(type)
            .calculation(calculation)
            .format(MetricFormat.inferFromType(type))
            .supportedDimensions(new ArrayList<>())
            .supportedFilters(new ArrayList<>())
            .defaultAggregation(AggregationType.SUM)
            .isCalculated(false)
            .isRealTime(false)
            .build();
    }

    public MetricValue calculate(AnalyticsContext context) {
        Object rawValue = calculation.compute(context);
        return MetricValue.of(this, rawValue, format);
    }

    public MetricValue aggregate(List<MetricValue> values, AggregationType aggregation) {
        AggregationType effectiveAggregation = aggregation != null ?
            aggregation : defaultAggregation;

        Object aggregatedValue = switch (effectiveAggregation) {
            case SUM -> values.stream()
                .mapToDouble(MetricValue::asDouble)
                .sum();
            case AVERAGE -> values.stream()
                .mapToDouble(MetricValue::asDouble)
                .average()
                .orElse(0.0);
            case COUNT -> (long) values.size();
            case MIN -> values.stream()
                .mapToDouble(MetricValue::asDouble)
                .min()
                .orElse(0.0);
            case MAX -> values.stream()
                .mapToDouble(MetricValue::asDouble)
                .max()
                .orElse(0.0);
            case DISTINCT_COUNT -> values.stream()
                .map(MetricValue::getRawValue)
                .distinct()
                .count();
        };

        return MetricValue.of(this, aggregatedValue, format);
    }

    public boolean supportsDimension(Dimension dimension) {
        return supportedDimensions.stream()
            .anyMatch(d -> d.getDimension().equals(dimension));
    }
}
```

### Entities

#### DashboardWidget Entity
```java
public class DashboardWidget {
    private WidgetId id;
    private String title;
    private WidgetType type;
    private WidgetConfiguration configuration;
    private WidgetPosition position;
    private WidgetDataSource dataSource;
    private RefreshInterval refreshInterval;
    private List<WidgetInteraction> interactions;
    private WidgetStyle style;

    public static DashboardWidget create(
            String title,
            WidgetType type,
            WidgetDataSource dataSource) {
        return DashboardWidget.builder()
            .id(WidgetId.generate())
            .title(title)
            .type(type)
            .dataSource(dataSource)
            .configuration(WidgetConfiguration.defaultFor(type))
            .position(WidgetPosition.origin())
            .refreshInterval(RefreshInterval.INHERIT)
            .interactions(new ArrayList<>())
            .style(WidgetStyle.defaultStyle())
            .build();
    }

    public WidgetData fetchData(DataFetcher fetcher, DateRange dateRange) {
        return fetcher.fetch(dataSource, dateRange);
    }

    public void updateConfiguration(WidgetConfiguration config) {
        this.configuration = config;
    }

    public void setPosition(WidgetPosition position) {
        this.position = position;
    }

    public void addInteraction(WidgetInteraction interaction) {
        interactions.add(interaction);
    }
}
```

#### ReportSection Entity
```java
public class ReportSection {
    private SectionId id;
    private String title;
    private SectionType type;
    private int order;
    private QueryDefinition query;
    private VisualizationType visualization;
    private VisualizationConfig visualizationConfig;
    private List<SectionColumn> columns;
    private boolean showInToc;
    private String description;

    public static ReportSection createMetricSection(
            String title,
            List<MetricId> metrics) {
        return ReportSection.builder()
            .id(SectionId.generate())
            .title(title)
            .type(SectionType.METRICS)
            .visualization(VisualizationType.KPI_CARDS)
            .query(QueryDefinition.forMetrics(metrics))
            .showInToc(true)
            .build();
    }

    public static ReportSection createChartSection(
            String title,
            QueryDefinition query,
            VisualizationType chartType) {
        return ReportSection.builder()
            .id(SectionId.generate())
            .title(title)
            .type(SectionType.CHART)
            .visualization(chartType)
            .query(query)
            .showInToc(true)
            .build();
    }

    public static ReportSection createTableSection(
            String title,
            QueryDefinition query,
            List<SectionColumn> columns) {
        return ReportSection.builder()
            .id(SectionId.generate())
            .title(title)
            .type(SectionType.TABLE)
            .visualization(VisualizationType.TABLE)
            .query(query)
            .columns(columns)
            .showInToc(true)
            .build();
    }

    public SectionData render(QueryExecutor executor, ReportFilters filters) {
        QueryResult queryResult = executor.execute(query, filters);
        return SectionData.builder()
            .sectionId(id)
            .title(title)
            .visualization(visualization)
            .data(queryResult)
            .config(visualizationConfig)
            .build();
    }
}
```

#### DataCube Entity
```java
public class DataCube {
    private DataCubeId id;
    private String name;
    private DataSource source;
    private List<Dimension> dimensions;
    private List<Measure> measures;
    private GranularityLevel granularity;
    private RetentionPolicy retentionPolicy;
    private MaterializationStrategy materializationStrategy;
    private Instant lastRefreshed;

    public CubeSlice query(CubeQuery query) {
        validateQuery(query);
        return executeCubeQuery(query);
    }

    public void refresh() {
        // Refresh materialized data
        this.lastRefreshed = Instant.now();
    }

    private void validateQuery(CubeQuery query) {
        // Ensure requested dimensions and measures exist
        for (Dimension dim : query.getDimensions()) {
            if (!dimensions.contains(dim)) {
                throw new InvalidCubeQueryException(
                    "Dimension not available: " + dim.getName());
            }
        }
        for (Measure measure : query.getMeasures()) {
            if (!measures.contains(measure)) {
                throw new InvalidCubeQueryException(
                    "Measure not available: " + measure.getName());
            }
        }
    }
}
```

### Value Objects

#### QueryDefinition Value Object
```java
public class QueryDefinition {
    private List<MetricId> metrics;
    private List<Dimension> dimensions;
    private List<QueryFilter> filters;
    private List<SortOrder> sorting;
    private GroupBy groupBy;
    private DateRangeType dateRangeType;
    private Integer limit;
    private Integer offset;

    public static QueryDefinition forMetrics(List<MetricId> metrics) {
        return QueryDefinition.builder()
            .metrics(metrics)
            .dimensions(new ArrayList<>())
            .filters(new ArrayList<>())
            .build();
    }

    public static QueryDefinition timeSeries(
            MetricId metric,
            Dimension timeDimension,
            GranularityLevel granularity) {
        return QueryDefinition.builder()
            .metrics(List.of(metric))
            .dimensions(List.of(timeDimension))
            .groupBy(GroupBy.byTime(granularity))
            .sorting(List.of(SortOrder.ascending(timeDimension)))
            .build();
    }

    public QueryDefinition copy() {
        return QueryDefinition.builder()
            .metrics(new ArrayList<>(metrics))
            .dimensions(new ArrayList<>(dimensions))
            .filters(new ArrayList<>(filters))
            .sorting(new ArrayList<>(sorting))
            .groupBy(groupBy)
            .dateRangeType(dateRangeType)
            .limit(limit)
            .offset(offset)
            .build();
    }

    public QueryDefinition withFilter(QueryFilter filter) {
        QueryDefinition copy = this.copy();
        copy.filters.add(filter);
        return copy;
    }

    public QueryDefinition withDateRange(DateRangeType rangeType) {
        QueryDefinition copy = this.copy();
        copy.dateRangeType = rangeType;
        return copy;
    }
}
```

#### Dimension Value Object
```java
public class Dimension {
    private String name;
    private String displayName;
    private DimensionType type;
    private String sourceField;
    private DimensionHierarchy hierarchy;

    public static Dimension time(String name, GranularityLevel granularity) {
        return Dimension.builder()
            .name(name)
            .displayName(toDisplayName(name))
            .type(DimensionType.TIME)
            .sourceField("timestamp")
            .hierarchy(DimensionHierarchy.time(granularity))
            .build();
    }

    public static Dimension categorical(String name, String sourceField) {
        return Dimension.builder()
            .name(name)
            .displayName(toDisplayName(name))
            .type(DimensionType.CATEGORICAL)
            .sourceField(sourceField)
            .build();
    }

    public static Dimension geographic(String name) {
        return Dimension.builder()
            .name(name)
            .displayName(toDisplayName(name))
            .type(DimensionType.GEOGRAPHIC)
            .hierarchy(DimensionHierarchy.geographic())
            .build();
    }

    public boolean supportsHierarchy() {
        return hierarchy != null;
    }

    public List<String> getHierarchyLevels() {
        return hierarchy != null ? hierarchy.getLevels() : List.of(name);
    }
}

public enum DimensionType {
    TIME,
    CATEGORICAL,
    NUMERIC_RANGE,
    GEOGRAPHIC,
    HIERARCHICAL
}
```

#### MetricValue Value Object
```java
public class MetricValue {
    private MetricId metricId;
    private Object rawValue;
    private String formattedValue;
    private MetricFormat format;
    private Instant calculatedAt;
    private ComparisonValue comparison;

    public static MetricValue of(Metric metric, Object value, MetricFormat format) {
        return MetricValue.builder()
            .metricId(metric.getId())
            .rawValue(value)
            .formattedValue(format.format(value))
            .format(format)
            .calculatedAt(Instant.now())
            .build();
    }

    public double asDouble() {
        if (rawValue instanceof Number) {
            return ((Number) rawValue).doubleValue();
        }
        throw new IllegalStateException("Cannot convert to double: " + rawValue);
    }

    public long asLong() {
        if (rawValue instanceof Number) {
            return ((Number) rawValue).longValue();
        }
        throw new IllegalStateException("Cannot convert to long: " + rawValue);
    }

    public MetricValue withComparison(MetricValue previous) {
        this.comparison = ComparisonValue.calculate(this, previous);
        return this;
    }
}
```

#### ComparisonValue Value Object
```java
public class ComparisonValue {
    private double absoluteChange;
    private double percentageChange;
    private TrendDirection trend;
    private String comparisonPeriod;

    public static ComparisonValue calculate(MetricValue current, MetricValue previous) {
        double currentVal = current.asDouble();
        double previousVal = previous.asDouble();

        double absoluteChange = currentVal - previousVal;
        double percentageChange = previousVal != 0 ?
            (absoluteChange / previousVal) * 100 : 0;

        TrendDirection trend = absoluteChange > 0 ? TrendDirection.UP :
            absoluteChange < 0 ? TrendDirection.DOWN : TrendDirection.FLAT;

        return new ComparisonValue(absoluteChange, percentageChange, trend, null);
    }

    public boolean isPositive() {
        return trend == TrendDirection.UP;
    }

    public boolean isNegative() {
        return trend == TrendDirection.DOWN;
    }

    public String getFormattedChange() {
        String sign = percentageChange >= 0 ? "+" : "";
        return String.format("%s%.1f%%", sign, percentageChange);
    }
}

public enum TrendDirection {
    UP,
    DOWN,
    FLAT
}
```

#### DateRange Value Object
```java
public class DateRange {
    private Instant start;
    private Instant end;
    private DateRangeType type;

    public static DateRange last7Days() {
        return new DateRange(
            Instant.now().minus(Duration.ofDays(7)),
            Instant.now(),
            DateRangeType.LAST_7_DAYS
        );
    }

    public static DateRange last30Days() {
        return new DateRange(
            Instant.now().minus(Duration.ofDays(30)),
            Instant.now(),
            DateRangeType.LAST_30_DAYS
        );
    }

    public static DateRange thisMonth() {
        LocalDate now = LocalDate.now();
        LocalDate firstOfMonth = now.withDayOfMonth(1);
        return new DateRange(
            firstOfMonth.atStartOfDay(ZoneOffset.UTC).toInstant(),
            Instant.now(),
            DateRangeType.THIS_MONTH
        );
    }

    public static DateRange custom(Instant start, Instant end) {
        return new DateRange(start, end, DateRangeType.CUSTOM);
    }

    public DateRange previousPeriod() {
        Duration duration = Duration.between(start, end);
        return new DateRange(
            start.minus(duration),
            start,
            DateRangeType.PREVIOUS_PERIOD
        );
    }

    public Duration getDuration() {
        return Duration.between(start, end);
    }

    public long getDays() {
        return getDuration().toDays();
    }

    public boolean contains(Instant instant) {
        return !instant.isBefore(start) && !instant.isAfter(end);
    }
}

public enum DateRangeType {
    TODAY,
    YESTERDAY,
    LAST_7_DAYS,
    LAST_30_DAYS,
    LAST_90_DAYS,
    THIS_WEEK,
    THIS_MONTH,
    THIS_QUARTER,
    THIS_YEAR,
    PREVIOUS_PERIOD,
    CUSTOM
}
```

#### WidgetConfiguration Value Object
```java
public class WidgetConfiguration {
    private Map<String, Object> options;
    private ChartConfig chartConfig;
    private TableConfig tableConfig;
    private KpiConfig kpiConfig;

    public static WidgetConfiguration defaultFor(WidgetType type) {
        return switch (type) {
            case LINE_CHART, AREA_CHART -> WidgetConfiguration.builder()
                .chartConfig(ChartConfig.builder()
                    .showLegend(true)
                    .showGrid(true)
                    .smoothCurve(true)
                    .build())
                .build();

            case BAR_CHART -> WidgetConfiguration.builder()
                .chartConfig(ChartConfig.builder()
                    .showLegend(true)
                    .showGrid(true)
                    .stacked(false)
                    .horizontal(false)
                    .build())
                .build();

            case PIE_CHART, DONUT_CHART -> WidgetConfiguration.builder()
                .chartConfig(ChartConfig.builder()
                    .showLegend(true)
                    .showLabels(true)
                    .build())
                .build();

            case DATA_TABLE -> WidgetConfiguration.builder()
                .tableConfig(TableConfig.builder()
                    .pageSize(10)
                    .sortable(true)
                    .filterable(true)
                    .build())
                .build();

            case KPI_CARD -> WidgetConfiguration.builder()
                .kpiConfig(KpiConfig.builder()
                    .showTrend(true)
                    .showComparison(true)
                    .comparisonPeriod(DateRangeType.PREVIOUS_PERIOD)
                    .build())
                .build();

            default -> new WidgetConfiguration();
        };
    }
}
```

#### VisualizationType Value Object
```java
public enum VisualizationType {
    // Charts
    LINE_CHART("Line Chart", ChartCategory.TIME_SERIES),
    AREA_CHART("Area Chart", ChartCategory.TIME_SERIES),
    BAR_CHART("Bar Chart", ChartCategory.COMPARISON),
    COLUMN_CHART("Column Chart", ChartCategory.COMPARISON),
    PIE_CHART("Pie Chart", ChartCategory.COMPOSITION),
    DONUT_CHART("Donut Chart", ChartCategory.COMPOSITION),
    STACKED_BAR("Stacked Bar", ChartCategory.COMPOSITION),
    SCATTER_PLOT("Scatter Plot", ChartCategory.CORRELATION),
    BUBBLE_CHART("Bubble Chart", ChartCategory.CORRELATION),
    HEATMAP("Heatmap", ChartCategory.DENSITY),
    TREEMAP("Treemap", ChartCategory.HIERARCHY),
    FUNNEL("Funnel", ChartCategory.FLOW),
    GAUGE("Gauge", ChartCategory.SINGLE_VALUE),

    // Tables and Lists
    TABLE("Data Table", ChartCategory.TABULAR),
    PIVOT_TABLE("Pivot Table", ChartCategory.TABULAR),
    LEADERBOARD("Leaderboard", ChartCategory.RANKING),

    // KPIs and Metrics
    KPI_CARDS("KPI Cards", ChartCategory.SINGLE_VALUE),
    METRIC_TREND("Metric with Trend", ChartCategory.SINGLE_VALUE),
    SPARKLINE("Sparkline", ChartCategory.SINGLE_VALUE),

    // Geographic
    MAP("Map", ChartCategory.GEOGRAPHIC),
    CHOROPLETH("Choropleth Map", ChartCategory.GEOGRAPHIC);

    private final String displayName;
    private final ChartCategory category;

    public boolean supportsTimeSeries() {
        return category == ChartCategory.TIME_SERIES;
    }

    public boolean supportsComparison() {
        return category == ChartCategory.COMPARISON ||
               category == ChartCategory.COMPOSITION;
    }
}

public enum ChartCategory {
    TIME_SERIES,
    COMPARISON,
    COMPOSITION,
    CORRELATION,
    DENSITY,
    HIERARCHY,
    FLOW,
    SINGLE_VALUE,
    TABULAR,
    RANKING,
    GEOGRAPHIC
}
```

#### ReportSchedule Value Object
```java
public class ReportSchedule {
    private ScheduleFrequency frequency;
    private LocalTime timeOfDay;
    private DayOfWeek dayOfWeek;          // For weekly
    private int dayOfMonth;                // For monthly
    private ZoneId timezone;
    private Instant lastRun;
    private Instant nextRun;
    private boolean enabled;

    public static ReportSchedule daily(LocalTime time, ZoneId timezone) {
        return ReportSchedule.builder()
            .frequency(ScheduleFrequency.DAILY)
            .timeOfDay(time)
            .timezone(timezone)
            .enabled(true)
            .nextRun(calculateNextRun(ScheduleFrequency.DAILY, time, timezone))
            .build();
    }

    public static ReportSchedule weekly(DayOfWeek day, LocalTime time, ZoneId timezone) {
        return ReportSchedule.builder()
            .frequency(ScheduleFrequency.WEEKLY)
            .dayOfWeek(day)
            .timeOfDay(time)
            .timezone(timezone)
            .enabled(true)
            .nextRun(calculateNextRun(ScheduleFrequency.WEEKLY, time, timezone))
            .build();
    }

    public static ReportSchedule monthly(int dayOfMonth, LocalTime time, ZoneId timezone) {
        return ReportSchedule.builder()
            .frequency(ScheduleFrequency.MONTHLY)
            .dayOfMonth(dayOfMonth)
            .timeOfDay(time)
            .timezone(timezone)
            .enabled(true)
            .nextRun(calculateNextRun(ScheduleFrequency.MONTHLY, time, timezone))
            .build();
    }

    public boolean isDue(Instant now) {
        return enabled && nextRun != null && !now.isBefore(nextRun);
    }

    public void markRun() {
        this.lastRun = Instant.now();
        this.nextRun = calculateNextRunFromNow();
    }

    private Instant calculateNextRunFromNow() {
        return calculateNextRun(frequency, timeOfDay, timezone);
    }
}

public enum ScheduleFrequency {
    DAILY,
    WEEKLY,
    MONTHLY,
    QUARTERLY
}
```

### Domain Services

#### AnalyticsEngine Domain Service
```java
@Service
public class AnalyticsEngine {
    private final DataCubeRepository dataCubeRepository;
    private final MetricRegistry metricRegistry;
    private final QueryOptimizer queryOptimizer;
    private final QueryCache queryCache;

    public QueryResult execute(QueryDefinition query) {
        // Check cache first
        String cacheKey = generateCacheKey(query);
        QueryResult cached = queryCache.get(cacheKey);
        if (cached != null) {
            return cached;
        }

        // Optimize query
        QueryDefinition optimized = queryOptimizer.optimize(query);

        // Execute against appropriate data source
        QueryResult result = executeQuery(optimized);

        // Cache result
        queryCache.put(cacheKey, result, getCacheDuration(query));

        return result;
    }

    public List<MetricValue> calculateMetrics(
            List<MetricId> metricIds,
            AnalyticsContext context) {

        return metricIds.stream()
            .map(id -> metricRegistry.getMetric(id))
            .map(metric -> metric.calculate(context))
            .collect(Collectors.toList());
    }

    public TimeSeriesData getTimeSeries(
            MetricId metricId,
            DateRange range,
            GranularityLevel granularity) {

        Metric metric = metricRegistry.getMetric(metricId);
        DataCube cube = dataCubeRepository.findForMetric(metricId)
            .orElseThrow(() -> new DataCubeNotFoundException(metricId));

        CubeQuery cubeQuery = CubeQuery.builder()
            .measure(metric.getName())
            .timeDimension("date")
            .granularity(granularity)
            .dateRange(range)
            .build();

        CubeSlice slice = cube.query(cubeQuery);
        return TimeSeriesData.fromSlice(slice, metric);
    }

    public ComparisonResult compareMetrics(
            List<MetricId> metricIds,
            DateRange currentPeriod,
            DateRange previousPeriod) {

        List<MetricValue> currentValues = calculateMetrics(
            metricIds,
            AnalyticsContext.forRange(currentPeriod)
        );

        List<MetricValue> previousValues = calculateMetrics(
            metricIds,
            AnalyticsContext.forRange(previousPeriod)
        );

        return ComparisonResult.compare(currentValues, previousValues);
    }
}
```

#### ReportGenerator Domain Service
```java
@Service
public class ReportGenerator {
    private final QueryExecutor queryExecutor;
    private final VisualizationRenderer visualizationRenderer;
    private final ExportService exportService;

    public ReportSnapshot generate(Report report, ReportFilters filters) {
        List<SectionData> sectionData = new ArrayList<>();

        for (ReportSection section : report.getSections()) {
            SectionData data = section.render(queryExecutor, filters);
            sectionData.add(data);
        }

        return ReportSnapshot.builder()
            .reportId(report.getId())
            .generatedAt(Instant.now())
            .filters(filters)
            .sections(sectionData)
            .build();
    }

    public byte[] export(ReportSnapshot snapshot, ExportFormat format) {
        return switch (format) {
            case PDF -> exportService.toPdf(snapshot);
            case CSV -> exportService.toCsv(snapshot);
            case EXCEL -> exportService.toExcel(snapshot);
            case JSON -> exportService.toJson(snapshot);
        };
    }

    public void deliverScheduledReport(Report report) {
        ReportSnapshot snapshot = generate(report, report.getDefaultFilters());
        byte[] content = export(snapshot, report.getExportConfig().getFormat());

        for (ReportRecipient recipient : report.getRecipients()) {
            deliverToRecipient(recipient, report, content);
        }

        report.getSchedule().markRun();
    }

    private void deliverToRecipient(
            ReportRecipient recipient,
            Report report,
            byte[] content) {
        // Send via configured channel (email, slack, etc.)
    }
}
```

#### DashboardRenderer Domain Service
```java
@Service
public class DashboardRenderer {
    private final WidgetDataFetcher dataFetcher;
    private final WidgetRenderer widgetRenderer;

    public DashboardSnapshot render(
            Dashboard dashboard,
            DateRange dateRange,
            List<DashboardFilter> filters) {

        List<WidgetSnapshot> widgetSnapshots = dashboard.getWidgets()
            .parallelStream()
            .map(widget -> renderWidget(widget, dateRange, filters))
            .collect(Collectors.toList());

        return DashboardSnapshot.builder()
            .dashboardId(dashboard.getId())
            .name(dashboard.getName())
            .renderedAt(Instant.now())
            .dateRange(dateRange)
            .widgets(widgetSnapshots)
            .build();
    }

    private WidgetSnapshot renderWidget(
            DashboardWidget widget,
            DateRange dateRange,
            List<DashboardFilter> filters) {

        WidgetData data = dataFetcher.fetch(
            widget.getDataSource(),
            dateRange,
            filters
        );

        return WidgetSnapshot.builder()
            .widgetId(widget.getId())
            .title(widget.getTitle())
            .type(widget.getType())
            .position(widget.getPosition())
            .data(data)
            .configuration(widget.getConfiguration())
            .build();
    }
}
```

## Predefined Metrics

### Platform Metrics
```java
public class PlatformMetrics {
    // User Metrics
    public static final Metric TOTAL_USERS = Metric.define(
        "total_users",
        MetricType.COUNT,
        ctx -> ctx.count("users")
    );

    public static final Metric DAILY_ACTIVE_USERS = Metric.define(
        "daily_active_users",
        MetricType.COUNT,
        ctx -> ctx.countDistinct("users", "last_active_date", ctx.today())
    ).withRealTime(true);

    public static final Metric WEEKLY_ACTIVE_USERS = Metric.define(
        "weekly_active_users",
        MetricType.COUNT,
        ctx -> ctx.countDistinct("users", "last_active_date", ctx.last7Days())
    );

    public static final Metric MONTHLY_ACTIVE_USERS = Metric.define(
        "monthly_active_users",
        MetricType.COUNT,
        ctx -> ctx.countDistinct("users", "last_active_date", ctx.last30Days())
    );

    public static final Metric NEW_USER_SIGNUPS = Metric.define(
        "new_user_signups",
        MetricType.COUNT,
        ctx -> ctx.count("users", "created_at", ctx.dateRange())
    );

    public static final Metric USER_RETENTION_RATE = Metric.define(
        "user_retention_rate",
        MetricType.PERCENTAGE,
        ctx -> ctx.retentionRate("users", ctx.cohortPeriod())
    );

    // League Metrics
    public static final Metric TOTAL_LEAGUES = Metric.define(
        "total_leagues",
        MetricType.COUNT,
        ctx -> ctx.count("leagues")
    );

    public static final Metric ACTIVE_LEAGUES = Metric.define(
        "active_leagues",
        MetricType.COUNT,
        ctx -> ctx.count("leagues", "status", "ACTIVE")
    );

    public static final Metric NEW_LEAGUES_CREATED = Metric.define(
        "new_leagues_created",
        MetricType.COUNT,
        ctx -> ctx.count("leagues", "created_at", ctx.dateRange())
    );

    public static final Metric AVERAGE_LEAGUE_SIZE = Metric.define(
        "average_league_size",
        MetricType.DECIMAL,
        ctx -> ctx.average("leagues", "team_count")
    );

    // Draft Metrics
    public static final Metric DRAFTS_COMPLETED = Metric.define(
        "drafts_completed",
        MetricType.COUNT,
        ctx -> ctx.count("drafts", "status", "COMPLETED")
    );

    public static final Metric DRAFT_COMPLETION_RATE = Metric.define(
        "draft_completion_rate",
        MetricType.PERCENTAGE,
        ctx -> {
            long completed = ctx.count("drafts", "status", "COMPLETED");
            long total = ctx.count("drafts");
            return total > 0 ? (double) completed / total * 100 : 0;
        }
    );

    public static final Metric AVERAGE_DRAFT_DURATION = Metric.define(
        "average_draft_duration",
        MetricType.DURATION,
        ctx -> ctx.averageDuration("drafts", "started_at", "completed_at")
    );

    // Engagement Metrics
    public static final Metric TRADES_EXECUTED = Metric.define(
        "trades_executed",
        MetricType.COUNT,
        ctx -> ctx.count("trades", "executed_at", ctx.dateRange())
    );

    public static final Metric WAIVER_CLAIMS = Metric.define(
        "waiver_claims",
        MetricType.COUNT,
        ctx -> ctx.count("waiver_claims", "processed_at", ctx.dateRange())
    );

    public static final Metric LINEUP_CHANGES = Metric.define(
        "lineup_changes",
        MetricType.COUNT,
        ctx -> ctx.count("lineup_changes", "changed_at", ctx.dateRange())
    );
}
```

## Port Interfaces

### Inbound Ports

```java
public interface DataInsightsPort {
    // Dashboard operations
    Dashboard getDashboard(DashboardId id);
    List<Dashboard> getDashboardsByType(DashboardType type);
    DashboardSnapshot renderDashboard(DashboardId id, DateRange dateRange);
    Dashboard createDashboard(CreateDashboardCommand command);
    Dashboard updateDashboard(UpdateDashboardCommand command);
    void deleteDashboard(DashboardId id);

    // Widget operations
    void addWidget(DashboardId dashboardId, AddWidgetCommand command);
    void updateWidget(DashboardId dashboardId, WidgetId widgetId, WidgetConfiguration config);
    void removeWidget(DashboardId dashboardId, WidgetId widgetId);
    WidgetData getWidgetData(WidgetId widgetId, DateRange dateRange);

    // Report operations
    Report getReport(ReportId id);
    List<Report> getReports(ReportSearchCriteria criteria);
    ReportSnapshot generateReport(ReportId id, ReportFilters filters);
    Report createReport(CreateReportCommand command);
    Report updateReport(UpdateReportCommand command);
    void deleteReport(ReportId id);
    byte[] exportReport(ReportId id, ExportFormat format, ReportFilters filters);
    void scheduleReport(ReportId id, ReportSchedule schedule);

    // Query operations
    AnalyticsQuery createQuery(CreateQueryCommand command);
    QueryResult executeQuery(QueryId id, ReportFilters filters);
    QueryResult executeAdHocQuery(QueryDefinition definition);
    List<AnalyticsQuery> getSavedQueries(AdminId adminId);
    List<AnalyticsQuery> getQueryTemplates();

    // Metrics operations
    List<MetricValue> getMetrics(List<MetricId> metricIds, DateRange dateRange);
    ComparisonResult compareMetrics(
        List<MetricId> metricIds,
        DateRange currentPeriod,
        DateRange previousPeriod);
    TimeSeriesData getTimeSeries(
        MetricId metricId,
        DateRange range,
        GranularityLevel granularity);
    List<Metric> getAvailableMetrics(MetricCategory category);

    // Dimension operations
    List<DimensionValue> getDimensionValues(Dimension dimension);
}

// Commands
@Value
public class CreateDashboardCommand {
    String name;
    String description;
    DashboardType type;
    AdminId ownerId;
}

@Value
public class AddWidgetCommand {
    String title;
    WidgetType type;
    WidgetDataSource dataSource;
    WidgetPosition position;
    WidgetConfiguration configuration;
}

@Value
public class CreateReportCommand {
    String name;
    String description;
    ReportType type;
    List<ReportSection> sections;
    ReportFilters defaultFilters;
    AdminId createdBy;
}

@Value
public class CreateQueryCommand {
    String name;
    String description;
    QueryDefinition definition;
    AdminId createdBy;
    boolean saveAsTemplate;
}
```

### Outbound Ports

```java
public interface DashboardRepository {
    Dashboard save(Dashboard dashboard);
    Optional<Dashboard> findById(DashboardId id);
    List<Dashboard> findByType(DashboardType type);
    List<Dashboard> findByOwner(AdminId ownerId);
    List<Dashboard> findPublic();
    void delete(DashboardId id);
}

public interface ReportRepository {
    Report save(Report report);
    Optional<Report> findById(ReportId id);
    List<Report> search(ReportSearchCriteria criteria);
    List<Report> findScheduledDueNow();
    void delete(ReportId id);
}

public interface AnalyticsQueryRepository {
    AnalyticsQuery save(AnalyticsQuery query);
    Optional<AnalyticsQuery> findById(QueryId id);
    List<AnalyticsQuery> findByCreator(AdminId adminId);
    List<AnalyticsQuery> findTemplates();
    List<AnalyticsQuery> findPublic();
    void delete(QueryId id);
}

public interface MetricRepository {
    Metric save(Metric metric);
    Optional<Metric> findById(MetricId id);
    Optional<Metric> findByName(String name);
    List<Metric> findByCategory(MetricCategory category);
    List<Metric> findAll();
}

public interface DataCubeRepository {
    DataCube save(DataCube cube);
    Optional<DataCube> findById(DataCubeId id);
    Optional<DataCube> findForMetric(MetricId metricId);
    List<DataCube> findAll();
}

public interface AnalyticsDataPort {
    // Raw data access for analytics
    long count(String collection, Map<String, Object> filters);
    double average(String collection, String field, Map<String, Object> filters);
    double sum(String collection, String field, Map<String, Object> filters);
    List<AggregationResult> aggregate(AggregationPipeline pipeline);
    List<Map<String, Object>> query(String collection, QuerySpec spec);
}

public interface QueryCache {
    QueryResult get(String cacheKey);
    void put(String cacheKey, QueryResult result, Duration ttl);
    void invalidate(String pattern);
    void clear();
}

public interface ReportDeliveryPort {
    void sendEmail(String recipient, String subject, byte[] attachment, ExportFormat format);
    void sendSlack(String channel, String message, byte[] attachment, ExportFormat format);
    void sendWebhook(String url, ReportSnapshot snapshot);
}
```

## REST API Endpoints

### Dashboard API
```yaml
/api/v1/admin/insights/dashboards:
  get:
    summary: List dashboards
    parameters:
      - name: type
        in: query
        schema:
          type: string
          enum: [EXECUTIVE, OPERATIONS, ENGAGEMENT, LEAGUES, DRAFTS]
      - name: includePublic
        in: query
        schema:
          type: boolean
    responses:
      200:
        content:
          application/json:
            schema:
              type: array
              items:
                $ref: '#/components/schemas/DashboardSummary'
  post:
    summary: Create dashboard
    requestBody:
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/CreateDashboardRequest'
    responses:
      201:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/DashboardResponse'

/api/v1/admin/insights/dashboards/{dashboardId}:
  get:
    summary: Get dashboard
    parameters:
      - name: dashboardId
        in: path
        required: true
        schema:
          type: string
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/DashboardResponse'

/api/v1/admin/insights/dashboards/{dashboardId}/render:
  get:
    summary: Render dashboard with data
    parameters:
      - name: dashboardId
        in: path
        required: true
        schema:
          type: string
      - name: startDate
        in: query
        schema:
          type: string
          format: date-time
      - name: endDate
        in: query
        schema:
          type: string
          format: date-time
      - name: dateRange
        in: query
        schema:
          type: string
          enum: [TODAY, LAST_7_DAYS, LAST_30_DAYS, THIS_MONTH, CUSTOM]
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/DashboardSnapshot'

/api/v1/admin/insights/dashboards/{dashboardId}/widgets:
  post:
    summary: Add widget to dashboard
    parameters:
      - name: dashboardId
        in: path
        required: true
        schema:
          type: string
    requestBody:
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/AddWidgetRequest'
    responses:
      201:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/WidgetResponse'

/api/v1/admin/insights/dashboards/{dashboardId}/widgets/{widgetId}:
  put:
    summary: Update widget
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/WidgetResponse'
  delete:
    summary: Remove widget
    responses:
      204:
        description: Widget removed
```

### Reports API
```yaml
/api/v1/admin/insights/reports:
  get:
    summary: List reports
    parameters:
      - name: type
        in: query
        schema:
          type: string
      - name: createdBy
        in: query
        schema:
          type: string
    responses:
      200:
        content:
          application/json:
            schema:
              type: array
              items:
                $ref: '#/components/schemas/ReportSummary'
  post:
    summary: Create report
    requestBody:
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/CreateReportRequest'
    responses:
      201:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ReportResponse'

/api/v1/admin/insights/reports/{reportId}/generate:
  post:
    summary: Generate report
    parameters:
      - name: reportId
        in: path
        required: true
        schema:
          type: string
    requestBody:
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ReportFilters'
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ReportSnapshot'

/api/v1/admin/insights/reports/{reportId}/export:
  get:
    summary: Export report
    parameters:
      - name: reportId
        in: path
        required: true
        schema:
          type: string
      - name: format
        in: query
        required: true
        schema:
          type: string
          enum: [PDF, CSV, EXCEL, JSON]
    responses:
      200:
        content:
          application/octet-stream:
            schema:
              type: string
              format: binary

/api/v1/admin/insights/reports/{reportId}/schedule:
  put:
    summary: Schedule report
    parameters:
      - name: reportId
        in: path
        required: true
        schema:
          type: string
    requestBody:
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ReportScheduleRequest'
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ReportResponse'
```

### Metrics API
```yaml
/api/v1/admin/insights/metrics:
  get:
    summary: Get available metrics
    parameters:
      - name: category
        in: query
        schema:
          type: string
          enum: [USERS, LEAGUES, DRAFTS, ENGAGEMENT, SCORING, SIMULATION]
    responses:
      200:
        content:
          application/json:
            schema:
              type: array
              items:
                $ref: '#/components/schemas/MetricDefinition'

/api/v1/admin/insights/metrics/values:
  post:
    summary: Get metric values
    requestBody:
      content:
        application/json:
          schema:
            type: object
            required:
              - metricIds
            properties:
              metricIds:
                type: array
                items:
                  type: string
              dateRange:
                $ref: '#/components/schemas/DateRange'
              compareWithPrevious:
                type: boolean
    responses:
      200:
        content:
          application/json:
            schema:
              type: array
              items:
                $ref: '#/components/schemas/MetricValueResponse'

/api/v1/admin/insights/metrics/{metricId}/timeseries:
  get:
    summary: Get metric time series
    parameters:
      - name: metricId
        in: path
        required: true
        schema:
          type: string
      - name: startDate
        in: query
        required: true
        schema:
          type: string
          format: date-time
      - name: endDate
        in: query
        required: true
        schema:
          type: string
          format: date-time
      - name: granularity
        in: query
        schema:
          type: string
          enum: [HOUR, DAY, WEEK, MONTH]
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/TimeSeriesResponse'
```

### Query API
```yaml
/api/v1/admin/insights/queries:
  get:
    summary: Get saved queries
    responses:
      200:
        content:
          application/json:
            schema:
              type: array
              items:
                $ref: '#/components/schemas/QuerySummary'
  post:
    summary: Create and save query
    requestBody:
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/CreateQueryRequest'
    responses:
      201:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/QueryResponse'

/api/v1/admin/insights/queries/execute:
  post:
    summary: Execute ad-hoc query
    requestBody:
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/QueryDefinition'
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/QueryResult'

/api/v1/admin/insights/queries/{queryId}/execute:
  post:
    summary: Execute saved query
    parameters:
      - name: queryId
        in: path
        required: true
        schema:
          type: string
    requestBody:
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/QueryFilters'
    responses:
      200:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/QueryResult'

/api/v1/admin/insights/queries/templates:
  get:
    summary: Get query templates
    responses:
      200:
        content:
          application/json:
            schema:
              type: array
              items:
                $ref: '#/components/schemas/QueryTemplate'
```

### Real-time API
```yaml
/ws/admin/insights/dashboard/{dashboardId}:
  description: Real-time dashboard updates
  subscribe:
    message:
      $ref: '#/components/schemas/DashboardUpdate'

/ws/admin/insights/metrics:
  description: Real-time metric updates
  subscribe:
    message:
      $ref: '#/components/schemas/MetricUpdate'
```

## MongoDB Collections

### dashboards Collection
```javascript
{
  _id: ObjectId,
  dashboardId: "dash_abc123",
  name: "Executive Overview",
  description: "High-level platform metrics",
  type: "EXECUTIVE",
  widgets: [
    {
      widgetId: "widget_001",
      title: "Daily Active Users",
      type: "KPI_CARD",
      configuration: {
        kpiConfig: {
          showTrend: true,
          showComparison: true,
          comparisonPeriod: "PREVIOUS_PERIOD"
        }
      },
      position: {
        x: 0,
        y: 0,
        width: 3,
        height: 2
      },
      dataSource: {
        type: "METRIC",
        metricId: "daily_active_users"
      },
      refreshInterval: "FIVE_MINUTES",
      interactions: [],
      style: {
        backgroundColor: "#ffffff",
        borderRadius: 8
      }
    },
    {
      widgetId: "widget_002",
      title: "User Growth Trend",
      type: "LINE_CHART",
      configuration: {
        chartConfig: {
          showLegend: true,
          showGrid: true,
          smoothCurve: true,
          colors: ["#4285f4"]
        }
      },
      position: {
        x: 3,
        y: 0,
        width: 6,
        height: 4
      },
      dataSource: {
        type: "TIME_SERIES",
        metricId: "new_user_signups",
        granularity: "DAY"
      }
    }
  ],
  layout: {
    type: "GRID",
    columns: 12,
    rowHeight: 60,
    margin: [10, 10]
  },
  refreshInterval: "FIVE_MINUTES",
  defaultDateRange: {
    type: "LAST_30_DAYS"
  },
  globalFilters: [],
  ownerId: "adm_xyz789",
  isDefault: true,
  isPublic: true,
  createdAt: ISODate("2024-01-15T10:00:00Z"),
  updatedAt: ISODate("2024-01-20T14:30:00Z")
}

// Indexes
db.dashboards.createIndex({ "dashboardId": 1 }, { unique: true })
db.dashboards.createIndex({ "type": 1 })
db.dashboards.createIndex({ "ownerId": 1 })
db.dashboards.createIndex({ "isPublic": 1, "type": 1 })
```

### reports Collection
```javascript
{
  _id: ObjectId,
  reportId: "rpt_abc123",
  name: "Weekly User Engagement Report",
  description: "Weekly summary of user engagement metrics",
  type: "ENGAGEMENT",
  layout: {
    pageSize: "A4",
    orientation: "PORTRAIT",
    margins: { top: 50, right: 40, bottom: 50, left: 40 }
  },
  sections: [
    {
      sectionId: "sec_001",
      title: "Key Metrics",
      type: "METRICS",
      order: 1,
      query: {
        metrics: ["daily_active_users", "weekly_active_users", "monthly_active_users"]
      },
      visualization: "KPI_CARDS",
      showInToc: true
    },
    {
      sectionId: "sec_002",
      title: "User Activity Trend",
      type: "CHART",
      order: 2,
      query: {
        metrics: ["daily_active_users"],
        dimensions: ["date"],
        groupBy: { type: "TIME", granularity: "DAY" }
      },
      visualization: "LINE_CHART",
      visualizationConfig: {
        showLegend: true,
        colors: ["#4285f4"]
      },
      showInToc: true
    },
    {
      sectionId: "sec_003",
      title: "Top Leagues by Activity",
      type: "TABLE",
      order: 3,
      query: {
        dimensions: ["league_id", "league_name"],
        metrics: ["activity_score"],
        sorting: [{ field: "activity_score", direction: "DESC" }],
        limit: 10
      },
      visualization: "TABLE",
      columns: [
        { field: "league_name", header: "League", width: 200 },
        { field: "activity_score", header: "Activity Score", width: 100 }
      ],
      showInToc: true
    }
  ],
  defaultFilters: {
    dateRange: { type: "LAST_7_DAYS" }
  },
  schedule: {
    frequency: "WEEKLY",
    dayOfWeek: "MONDAY",
    timeOfDay: "09:00",
    timezone: "America/New_York",
    enabled: true,
    lastRun: ISODate("2024-01-15T14:00:00Z"),
    nextRun: ISODate("2024-01-22T14:00:00Z")
  },
  recipients: [
    {
      type: "EMAIL",
      address: "leadership@example.com",
      name: "Leadership Team"
    },
    {
      type: "SLACK",
      channel: "#analytics",
      name: "Analytics Channel"
    }
  ],
  exportConfig: {
    format: "PDF",
    includeRawData: false
  },
  createdBy: "adm_xyz789",
  createdAt: ISODate("2024-01-01T10:00:00Z"),
  updatedAt: ISODate("2024-01-10T15:30:00Z")
}

// Indexes
db.reports.createIndex({ "reportId": 1 }, { unique: true })
db.reports.createIndex({ "type": 1 })
db.reports.createIndex({ "createdBy": 1 })
db.reports.createIndex({ "schedule.enabled": 1, "schedule.nextRun": 1 })
```

### analytics_queries Collection
```javascript
{
  _id: ObjectId,
  queryId: "qry_abc123",
  name: "League Retention Analysis",
  description: "Analyze league retention by creation cohort",
  definition: {
    metrics: ["active_leagues", "retention_rate"],
    dimensions: ["creation_month", "league_type"],
    filters: [
      { field: "status", operator: "IN", values: ["ACTIVE", "COMPLETED"] }
    ],
    sorting: [
      { field: "creation_month", direction: "ASC" }
    ],
    groupBy: {
      dimensions: ["creation_month", "league_type"]
    },
    dateRangeType: "LAST_90_DAYS"
  },
  createdBy: "adm_xyz789",
  createdAt: ISODate("2024-01-15T10:00:00Z"),
  lastExecutedAt: ISODate("2024-01-20T09:15:00Z"),
  executionStats: {
    totalExecutions: 25,
    averageDurationMs: 450,
    lastDurationMs: 380
  },
  isTemplate: true,
  isPublic: true,
  tags: ["retention", "cohort", "leagues"]
}

// Indexes
db.analytics_queries.createIndex({ "queryId": 1 }, { unique: true })
db.analytics_queries.createIndex({ "createdBy": 1 })
db.analytics_queries.createIndex({ "isTemplate": 1 })
db.analytics_queries.createIndex({ "isPublic": 1 })
db.analytics_queries.createIndex({ "tags": 1 })
```

### metrics Collection
```javascript
{
  _id: ObjectId,
  metricId: "daily_active_users",
  name: "daily_active_users",
  displayName: "Daily Active Users",
  description: "Number of unique users active in the last 24 hours",
  type: "COUNT",
  category: "USERS",
  calculation: {
    type: "QUERY",
    collection: "users",
    aggregation: "COUNT_DISTINCT",
    field: "userId",
    filter: {
      lastActiveAt: { "$gte": "$$CURRENT_DATE_MINUS_1_DAY" }
    }
  },
  format: {
    type: "NUMBER",
    decimals: 0,
    abbreviate: true
  },
  supportedDimensions: [
    { dimension: "date", displayName: "Date" },
    { dimension: "platform", displayName: "Platform" },
    { dimension: "region", displayName: "Region" }
  ],
  supportedFilters: [
    { field: "platform", operators: ["EQUALS", "IN"] },
    { field: "region", operators: ["EQUALS", "IN"] }
  ],
  defaultAggregation: "SUM",
  isCalculated: false,
  isRealTime: true,
  dataSource: {
    type: "MONGODB",
    collection: "users"
  }
}

// Indexes
db.metrics.createIndex({ "metricId": 1 }, { unique: true })
db.metrics.createIndex({ "name": 1 }, { unique: true })
db.metrics.createIndex({ "category": 1 })
```

### data_cubes Collection
```javascript
{
  _id: ObjectId,
  cubeId: "cube_user_activity",
  name: "User Activity Cube",
  source: {
    type: "MONGODB",
    collection: "user_activities"
  },
  dimensions: [
    { name: "date", type: "TIME", sourceField: "activityDate" },
    { name: "userId", type: "CATEGORICAL", sourceField: "userId" },
    { name: "activityType", type: "CATEGORICAL", sourceField: "type" },
    { name: "platform", type: "CATEGORICAL", sourceField: "platform" }
  ],
  measures: [
    { name: "activityCount", aggregation: "COUNT" },
    { name: "uniqueUsers", aggregation: "COUNT_DISTINCT", field: "userId" },
    { name: "sessionDuration", aggregation: "SUM", field: "duration" }
  ],
  granularity: "HOUR",
  retentionPolicy: {
    rawData: "90_DAYS",
    hourlyRollup: "1_YEAR",
    dailyRollup: "INDEFINITE"
  },
  materializationStrategy: {
    type: "INCREMENTAL",
    schedule: "*/15 * * * *"
  },
  lastRefreshed: ISODate("2024-01-20T15:00:00Z")
}

// Indexes
db.data_cubes.createIndex({ "cubeId": 1 }, { unique: true })
db.data_cubes.createIndex({ "name": 1 })
```

### analytics_cache Collection
```javascript
{
  _id: ObjectId,
  cacheKey: "hash_abc123def456",
  queryHash: "sha256:abc123...",
  result: {
    // Cached query result data
    columns: ["date", "value"],
    rows: [
      ["2024-01-15", 1250],
      ["2024-01-16", 1340]
    ],
    metadata: {
      rowCount: 30,
      executionTimeMs: 450
    }
  },
  createdAt: ISODate("2024-01-20T15:30:00Z"),
  expiresAt: ISODate("2024-01-20T15:45:00Z")
}

// Indexes
db.analytics_cache.createIndex({ "cacheKey": 1 }, { unique: true })
db.analytics_cache.createIndex({ "expiresAt": 1 }, { expireAfterSeconds: 0 })
```

## Gherkin Feature File

```gherkin
Feature: Admin Data Insights
  As an administrator
  I want to access analytics and insights about platform data
  So that I can make informed business decisions

  Background:
    Given an authenticated super admin "analyst@example.com"
    And the analytics system is configured with sample data

  # Dashboard Management

  Scenario: View executive dashboard
    Given the executive dashboard exists with default widgets
    When I open the executive dashboard
    Then I should see the following KPI widgets:
      | widget              | type     |
      | Daily Active Users  | KPI_CARD |
      | Total Leagues       | KPI_CARD |
      | Drafts Completed    | KPI_CARD |
    And each KPI should show current value and trend

  Scenario: Change dashboard date range
    Given I am viewing the executive dashboard
    When I change the date range to "Last 7 Days"
    Then all widgets should refresh with the new date range
    And the comparison should show change from previous 7 days

  Scenario: Create custom dashboard
    When I create a new dashboard with name "My Analytics"
    And I add a line chart widget for "Daily Active Users"
    And I add a bar chart widget for "Leagues by Type"
    Then the dashboard should be saved successfully
    And I should see both widgets on the dashboard

  Scenario: Rearrange dashboard widgets
    Given I have a dashboard with 4 widgets
    When I drag the "User Growth" widget to position (0, 0)
    And I resize it to span 6 columns
    Then the widget positions should be updated
    And other widgets should reflow accordingly

  Scenario: Configure widget settings
    Given I have a line chart widget on my dashboard
    When I configure the widget to:
      | setting      | value |
      | showLegend   | false |
      | smoothCurve  | true  |
      | granularity  | WEEK  |
    Then the widget should update with new settings

  # Metrics and KPIs

  Scenario: View platform metrics with comparison
    When I request the following metrics for "Last 30 Days":
      | metric              |
      | daily_active_users  |
      | new_user_signups    |
      | total_leagues       |
    Then I should see current values for each metric
    And I should see comparison with previous period
    And trending indicators should show up/down/flat

  Scenario: View time series for a metric
    When I request time series for "daily_active_users"
    With date range "2024-01-01" to "2024-01-31"
    And granularity "DAY"
    Then I should receive 31 data points
    And each data point should have date and value

  Scenario: Drill down into metric
    Given I am viewing the "Total Leagues" KPI
    When I click to drill down
    Then I should see leagues broken down by:
      | dimension    |
      | League Type  |
      | Creation Month |
      | Status       |

  # Report Generation

  Scenario: Generate engagement report
    Given a "Weekly Engagement" report template exists
    When I generate the report for "Last Week"
    Then the report should contain:
      | section               | type       |
      | Key Metrics           | KPI_CARDS  |
      | User Activity Trend   | LINE_CHART |
      | Top Active Leagues    | TABLE      |
    And all data should be for the specified period

  Scenario: Export report as PDF
    Given I have generated a report
    When I export the report as PDF
    Then I should receive a PDF file
    And the PDF should contain all report sections
    And the PDF should include generation timestamp

  Scenario: Export report as CSV
    Given I have generated a report with table data
    When I export the report as CSV
    Then I should receive a CSV file
    And the CSV should contain headers matching table columns
    And the CSV should contain all data rows

  Scenario: Schedule recurring report
    Given I have created a report "Weekly Summary"
    When I schedule the report with:
      | frequency  | WEEKLY            |
      | dayOfWeek  | MONDAY            |
      | time       | 09:00             |
      | timezone   | America/New_York  |
      | recipients | team@example.com  |
    Then the report schedule should be saved
    And the next run should be calculated correctly

  Scenario: Receive scheduled report
    Given a scheduled report is due now
    When the scheduler runs
    Then the report should be generated
    And recipients should receive the report via email

  # Custom Queries

  Scenario: Create and save custom query
    When I create a query with:
      | metric     | active_leagues            |
      | dimension  | creation_month            |
      | filter     | status IN (ACTIVE)        |
      | sort       | creation_month ASC        |
    And I save it as "League Creation Trend"
    Then the query should be saved to my queries
    And I should be able to execute it later

  Scenario: Execute ad-hoc query
    When I execute an ad-hoc query:
      """
      metrics: [trades_executed, waiver_claims]
      dimensions: [league_type]
      dateRange: LAST_30_DAYS
      groupBy: league_type
      """
    Then I should receive query results
    And results should be grouped by league type

  Scenario: Use query template
    Given a query template "Cohort Retention" exists
    When I clone the template for my use
    And I modify the date range to "Last 90 Days"
    And I execute the query
    Then I should see retention data by cohort

  # Real-time Updates

  Scenario: Dashboard real-time refresh
    Given I am viewing a dashboard with 5-minute refresh
    When a widget's underlying data changes
    Then the widget should auto-refresh after interval
    And I should see updated values

  Scenario: Subscribe to metric updates
    Given I am monitoring "daily_active_users" in real-time
    When new user activity is recorded
    Then I should receive a WebSocket update
    And the displayed value should update

  # Data Dimensions

  Scenario: Filter by dimension
    Given I am viewing the user engagement dashboard
    When I apply a global filter "Platform = iOS"
    Then all widgets should show iOS-only data
    And the filter should persist across page navigation

  Scenario: Compare dimensions
    When I create a comparison view with:
      | metric     | daily_active_users |
      | dimension  | platform           |
      | values     | iOS, Android       |
    Then I should see side-by-side comparison
    And each platform should have its own trend line

  # Performance

  Scenario: Query caching
    Given I execute a complex query
    When I execute the same query again within 5 minutes
    Then the result should be served from cache
    And response time should be under 100ms

  Scenario: Large dataset handling
    Given a dashboard with queries over 1 million records
    When I render the dashboard
    Then the dashboard should load within 3 seconds
    And aggregated data should be accurate
```

## Files to Create

### Domain Layer
```
src/main/java/com/fflplayoffs/admin/insights/domain/
├── model/
│   ├── Dashboard.java
│   ├── DashboardId.java
│   ├── DashboardWidget.java
│   ├── WidgetId.java
│   ├── Report.java
│   ├── ReportId.java
│   ├── ReportSection.java
│   ├── SectionId.java
│   ├── AnalyticsQuery.java
│   ├── QueryId.java
│   ├── Metric.java
│   ├── MetricId.java
│   └── DataCube.java
├── vo/
│   ├── QueryDefinition.java
│   ├── Dimension.java
│   ├── DimensionType.java
│   ├── MetricValue.java
│   ├── ComparisonValue.java
│   ├── TrendDirection.java
│   ├── DateRange.java
│   ├── DateRangeType.java
│   ├── WidgetConfiguration.java
│   ├── WidgetPosition.java
│   ├── WidgetType.java
│   ├── VisualizationType.java
│   ├── ChartCategory.java
│   ├── ReportSchedule.java
│   ├── ScheduleFrequency.java
│   ├── ReportFilters.java
│   ├── QueryFilter.java
│   ├── AggregationType.java
│   ├── GranularityLevel.java
│   └── ExportFormat.java
├── service/
│   ├── AnalyticsEngine.java
│   ├── ReportGenerator.java
│   ├── DashboardRenderer.java
│   └── MetricCalculator.java
└── event/
    ├── DashboardUpdatedEvent.java
    └── ReportGeneratedEvent.java
```

### Port Layer
```
src/main/java/com/fflplayoffs/admin/insights/port/
├── inbound/
│   ├── DataInsightsPort.java
│   ├── command/
│   │   ├── CreateDashboardCommand.java
│   │   ├── UpdateDashboardCommand.java
│   │   ├── AddWidgetCommand.java
│   │   ├── CreateReportCommand.java
│   │   ├── UpdateReportCommand.java
│   │   └── CreateQueryCommand.java
│   └── query/
│       ├── ReportSearchCriteria.java
│       └── DashboardSearchCriteria.java
└── outbound/
    ├── DashboardRepository.java
    ├── ReportRepository.java
    ├── AnalyticsQueryRepository.java
    ├── MetricRepository.java
    ├── DataCubeRepository.java
    ├── AnalyticsDataPort.java
    ├── QueryCache.java
    └── ReportDeliveryPort.java
```

### Adapter Layer
```
src/main/java/com/fflplayoffs/admin/insights/adapter/
├── inbound/
│   └── rest/
│       ├── DashboardController.java
│       ├── ReportController.java
│       ├── MetricsController.java
│       ├── QueryController.java
│       └── dto/
│           ├── DashboardResponse.java
│           ├── DashboardSnapshot.java
│           ├── WidgetResponse.java
│           ├── CreateDashboardRequest.java
│           ├── AddWidgetRequest.java
│           ├── ReportResponse.java
│           ├── ReportSnapshot.java
│           ├── CreateReportRequest.java
│           ├── MetricValueResponse.java
│           ├── TimeSeriesResponse.java
│           ├── QueryResponse.java
│           └── QueryResult.java
├── outbound/
│   ├── persistence/
│   │   ├── MongoDashboardRepository.java
│   │   ├── MongoReportRepository.java
│   │   ├── MongoAnalyticsQueryRepository.java
│   │   ├── MongoMetricRepository.java
│   │   ├── MongoDataCubeRepository.java
│   │   ├── RedisQueryCache.java
│   │   └── document/
│   │       ├── DashboardDocument.java
│   │       ├── ReportDocument.java
│   │       ├── AnalyticsQueryDocument.java
│   │       ├── MetricDocument.java
│   │       └── DataCubeDocument.java
│   ├── analytics/
│   │   └── MongoAnalyticsDataAdapter.java
│   └── delivery/
│       ├── EmailReportDeliveryAdapter.java
│       └── SlackReportDeliveryAdapter.java
└── websocket/
    ├── DashboardUpdateHandler.java
    └── MetricUpdateHandler.java
```

### Application Layer
```
src/main/java/com/fflplayoffs/admin/insights/application/
├── DataInsightsApplicationService.java
├── ReportSchedulerService.java
├── MetricRegistryService.java
└── mapper/
    ├── DashboardMapper.java
    ├── ReportMapper.java
    └── QueryMapper.java
```

### Infrastructure
```
src/main/java/com/fflplayoffs/admin/insights/infrastructure/
├── config/
│   ├── InsightsConfig.java
│   ├── CacheConfig.java
│   └── SchedulerConfig.java
├── metrics/
│   └── PredefinedMetrics.java
└── export/
    ├── PdfExportService.java
    ├── CsvExportService.java
    └── ExcelExportService.java
```

### Test Files
```
src/test/java/com/fflplayoffs/admin/insights/
├── domain/
│   ├── DashboardTest.java
│   ├── ReportTest.java
│   ├── AnalyticsEngineTest.java
│   └── MetricCalculatorTest.java
├── adapter/
│   ├── DashboardControllerTest.java
│   ├── ReportControllerTest.java
│   └── MongoAnalyticsRepositoryTest.java
└── integration/
    ├── DashboardIntegrationTest.java
    ├── ReportGenerationIntegrationTest.java
    └── QueryExecutionIntegrationTest.java

src/test/resources/features/
└── admin-data-insights.feature
```

## Implementation Priority

### Phase 1: Core Metrics (Sprint 1)
1. Metric domain model and registry
2. Predefined platform metrics
3. MetricRepository and MongoDB persistence
4. Basic metrics API endpoint
5. Metric calculation engine

### Phase 2: Dashboards (Sprint 1-2)
1. Dashboard and Widget domain models
2. DashboardRepository with MongoDB
3. Widget types (KPI, charts, tables)
4. Dashboard CRUD API
5. Dashboard rendering service

### Phase 3: Visualization (Sprint 2)
1. Chart configuration value objects
2. Time series data generation
3. Comparison calculations
4. Frontend chart integration
5. Real-time WebSocket updates

### Phase 4: Reports (Sprint 2-3)
1. Report and Section domain models
2. ReportRepository with MongoDB
3. Report generation service
4. Export service (PDF, CSV, Excel)
5. Report scheduling

### Phase 5: Custom Queries (Sprint 3)
1. AnalyticsQuery domain model
2. Query builder and optimizer
3. Query caching (Redis)
4. Query templates
5. Ad-hoc query execution

### Phase 6: Advanced Features (Sprint 3-4)
1. Data cube materialization
2. Drill-down functionality
3. Anomaly detection
4. Forecasting
5. Complete Gherkin coverage

## Performance Considerations

1. **Query Optimization**:
   - Use materialized views for common aggregations
   - Implement query caching with Redis
   - Create appropriate MongoDB indexes

2. **Data Cubes**:
   - Pre-aggregate at multiple granularities
   - Incremental refresh strategy
   - Partition by time for large datasets

3. **Real-time Updates**:
   - Use change streams for live data
   - Debounce frequent updates
   - Implement progressive loading

4. **Export Performance**:
   - Stream large exports
   - Async generation for big reports
   - Compress large files
