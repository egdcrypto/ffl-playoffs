# Location Entity Curation Architecture

> **ANIMA-1043**: Design and architecture for Location Entity management

## Overview

Location Entities provide geospatial context for fantasy football simulations, enabling:

- **Stadium Modeling**: NFL venue characteristics (dome, outdoor, altitude, surface)
- **Weather Simulation**: Location-based weather patterns and effects
- **Travel Impact**: Distance-based fatigue and schedule considerations
- **Time Zone Handling**: Game scheduling across time zones
- **Climate Zones**: Regional weather tendencies for realistic simulation

Locations integrate with the World Event system (weather events), Simulation World (team home venues), and game scheduling.

---

## Use Cases

### Primary Use Cases

1. **Define Stadium Location**
   - Create stadium with geospatial coordinates
   - Specify venue characteristics (dome, capacity, surface)
   - Associate with home team(s)
   - Configure weather susceptibility

2. **Model Weather Zones**
   - Define climate regions with weather probabilities
   - Configure seasonal weather patterns
   - Map stadiums to weather zones
   - Set weather effect parameters

3. **Calculate Travel Impact**
   - Compute distance between locations
   - Estimate travel time and fatigue effects
   - Factor in time zone changes
   - Apply rest/fatigue modifiers

4. **Query Location Data**
   - Get stadium details by team
   - Find stadiums in weather zone
   - List outdoor vs dome venues
   - Get time zone for game scheduling

5. **Generate Location-Based Events**
   - Create weather events based on location/season
   - Apply altitude effects for high-elevation venues
   - Factor surface type into injury probabilities
   - Model home field advantage by venue

---

## Domain Model

### 1. Stadium (Aggregate Root)

Represents an NFL stadium or venue.

**Location**: `domain/aggregate/Stadium.java`

```java
public class Stadium {

    private UUID id;
    private String name;                    // "Arrowhead Stadium"
    private String code;                    // "ARROWHEAD"

    // Team association
    private String primaryTeamAbbreviation; // "KC"
    private List<String> tenantTeams;       // For shared stadiums

    // Location
    private GeoCoordinates coordinates;
    private Address address;
    private String timeZone;                // "America/Chicago"
    private WeatherZone weatherZone;

    // Venue characteristics
    private VenueType venueType;            // OUTDOOR, DOME, RETRACTABLE
    private SurfaceType surfaceType;        // GRASS, TURF, HYBRID
    private Integer capacity;
    private Integer elevation;              // Feet above sea level

    // Simulation factors
    private Double homeFieldAdvantage;      // Baseline HFA multiplier
    private Double noiseFactor;             // Crowd noise impact
    private Double weatherExposure;         // 0.0 (dome) to 1.0 (full outdoor)

    // Historical data
    private Map<Integer, SeasonWeatherProfile> historicalWeather;

    // Metadata
    private Integer openedYear;
    private Boolean isActive;
    private LocalDateTime updatedAt;

    // Business methods
    public boolean isOutdoor();
    public boolean isDome();
    public boolean isHighAltitude();        // > 5000 ft
    public WeatherModifier getWeatherModifier(WeatherConditions conditions);
    public Double getEffectiveHFA(TeamStrengthProfile homeTeam);
}
```

**VenueType Enum**:
```java
public enum VenueType {
    OUTDOOR("Fully exposed to weather"),
    DOME("Enclosed, climate controlled"),
    RETRACTABLE("Retractable roof, can open/close");

    private final String description;

    public boolean isWeatherExposed() {
        return this == OUTDOOR;
    }
}
```

**SurfaceType Enum**:
```java
public enum SurfaceType {
    NATURAL_GRASS("Natural grass surface", 1.0),
    ARTIFICIAL_TURF("Synthetic turf", 1.15),
    HYBRID("Natural/synthetic hybrid", 1.05);

    private final String description;
    private final double injuryMultiplier;  // Relative injury risk
}
```

### 2. GeoCoordinates (Value Object)

Represents a geographic point.

**Location**: `domain/model/GeoCoordinates.java`

```java
public class GeoCoordinates {

    private final Double latitude;          // -90 to 90
    private final Double longitude;         // -180 to 180

    // Validation
    public static GeoCoordinates of(double lat, double lon) {
        if (lat < -90 || lat > 90) {
            throw new InvalidCoordinateException("Latitude must be between -90 and 90");
        }
        if (lon < -180 || lon > 180) {
            throw new InvalidCoordinateException("Longitude must be between -180 and 180");
        }
        return new GeoCoordinates(lat, lon);
    }

    // Distance calculation
    public Distance distanceTo(GeoCoordinates other) {
        // Haversine formula for great-circle distance
        double earthRadius = 3959; // miles
        double dLat = Math.toRadians(other.latitude - this.latitude);
        double dLon = Math.toRadians(other.longitude - this.longitude);

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                   Math.cos(Math.toRadians(this.latitude)) *
                   Math.cos(Math.toRadians(other.latitude)) *
                   Math.sin(dLon / 2) * Math.sin(dLon / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return Distance.miles(earthRadius * c);
    }

    // Time zone offset
    public int getTimeZoneOffset(GeoCoordinates other) {
        // Approximate hours difference based on longitude
        return (int) Math.round((other.longitude - this.longitude) / 15.0);
    }
}
```

### 3. Address (Value Object)

Physical address of a location.

**Location**: `domain/model/Address.java`

```java
public class Address {

    private final String street;
    private final String city;
    private final String state;             // Or province
    private final String postalCode;
    private final String country;

    // For display
    public String getShortForm() {
        return city + ", " + state;
    }

    public String getFullAddress() {
        return String.format("%s, %s, %s %s, %s",
            street, city, state, postalCode, country);
    }
}
```

### 4. WeatherZone (Entity)

Defines a climate region with weather characteristics.

**Location**: `domain/entity/WeatherZone.java`

```java
public class WeatherZone {

    private UUID id;
    private String name;                    // "Great Lakes"
    private String code;                    // "GREAT_LAKES"
    private ClimateType climateType;

    // Geographic bounds (optional)
    private GeoBoundingBox bounds;

    // Weather probabilities by month (1-12)
    private Map<Integer, MonthlyWeatherProfile> monthlyProfiles;

    // Seasonal patterns
    private SeasonalWeatherPattern winterPattern;
    private SeasonalWeatherPattern springPattern;
    private SeasonalWeatherPattern summerPattern;
    private SeasonalWeatherPattern fallPattern;

    // Temperature ranges by month (Fahrenheit)
    private Map<Integer, TemperatureRange> monthlyTemperatures;

    // Precipitation characteristics
    private Double annualPrecipitationInches;
    private Double annualSnowfallInches;

    // Business methods
    public WeatherConditions generateWeather(Integer month, Random random);
    public WeatherProbabilities getWeatherProbabilities(Integer month);
    public boolean isSnowPossible(Integer month);
    public boolean isExtremeColdPossible(Integer month);
    public TemperatureRange getTemperatureRange(Integer month);
}
```

**ClimateType Enum**:
```java
public enum ClimateType {
    CONTINENTAL("Cold winters, warm summers", true, true),
    HUMID_SUBTROPICAL("Mild winters, hot humid summers", false, true),
    MEDITERRANEAN("Mild, dry summers", false, false),
    SEMI_ARID("Low precipitation, wide temp range", false, false),
    OCEANIC("Mild, frequent rain", false, true),
    TROPICAL("Warm year-round, high humidity", false, true),
    DESERT("Hot, minimal precipitation", false, false),
    ALPINE("Cold, high altitude effects", true, true);

    private final String description;
    private final boolean snowPossible;
    private final boolean rainCommon;
}
```

### 5. MonthlyWeatherProfile (Value Object)

Weather probabilities for a specific month.

**Location**: `domain/model/MonthlyWeatherProfile.java`

```java
public class MonthlyWeatherProfile {

    private Integer month;                  // 1-12

    // Condition probabilities (sum to ~1.0)
    private Double clearProbability;
    private Double cloudyProbability;
    private Double rainProbability;
    private Double snowProbability;
    private Double stormProbability;

    // Wind characteristics
    private Double calmWindProbability;
    private Double moderateWindProbability;
    private Double highWindProbability;
    private Double averageWindSpeed;        // MPH

    // Temperature
    private Double averageHigh;             // Fahrenheit
    private Double averageLow;
    private Double recordHigh;
    private Double recordLow;

    // Humidity
    private Double averageHumidity;         // Percentage

    // Factory for NFL cities
    public static MonthlyWeatherProfile kansasCity(int month);
    public static MonthlyWeatherProfile greenBay(int month);
    public static MonthlyWeatherProfile miami(int month);
    public static MonthlyWeatherProfile denver(int month);
}
```

### 6. WeatherConditions (Value Object)

Current or simulated weather at a location.

**Location**: `domain/model/WeatherConditions.java`

```java
public class WeatherConditions {

    private WeatherType type;               // CLEAR, RAIN, SNOW, etc.
    private Integer temperature;            // Fahrenheit
    private Integer humidity;               // Percentage
    private Integer windSpeed;              // MPH
    private WindDirection windDirection;
    private PrecipitationType precipitation;
    private Double precipitationIntensity;  // 0.0-1.0
    private Integer visibility;             // Miles
    private Boolean lightning;

    // Derived conditions
    private Integer feelsLike;              // Wind chill / heat index
    private FieldCondition fieldCondition;  // DRY, WET, MUDDY, FROZEN, SNOWY

    // Effect calculations
    public StatModifiers getStatModifiers();
    public Double getPassingModifier();
    public Double getKickingModifier();
    public Double getInjuryModifier();

    // Classification
    public boolean isExtreme();
    public boolean isPrecipitating();
    public boolean isCold();                // < 32F
    public boolean isHot();                 // > 90F
    public WeatherSeverity getSeverity();

    // Factory methods
    public static WeatherConditions ideal();
    public static WeatherConditions rain(int temp, int windSpeed);
    public static WeatherConditions snow(int temp, double intensity);
    public static WeatherConditions extremeCold(int temp, int windSpeed);
    public static WeatherConditions dome();
}
```

**WeatherType Enum**:
```java
public enum WeatherType {
    CLEAR("Clear skies", 1.0),
    PARTLY_CLOUDY("Partly cloudy", 1.0),
    CLOUDY("Overcast", 1.0),
    LIGHT_RAIN("Light rain", 0.95),
    RAIN("Rain", 0.90),
    HEAVY_RAIN("Heavy rain", 0.80),
    THUNDERSTORM("Thunderstorm", 0.75),
    LIGHT_SNOW("Light snow", 0.90),
    SNOW("Snow", 0.80),
    HEAVY_SNOW("Heavy snow", 0.65),
    SLEET("Sleet/ice", 0.70),
    FOG("Fog", 0.85),
    WIND("High winds", 0.85);

    private final String description;
    private final double basePassingModifier;
}
```

### 7. Distance (Value Object)

Represents distance between locations.

**Location**: `domain/model/Distance.java`

```java
public class Distance {

    private final Double value;
    private final DistanceUnit unit;

    // Factory methods
    public static Distance miles(double miles) {
        return new Distance(miles, DistanceUnit.MILES);
    }

    public static Distance kilometers(double km) {
        return new Distance(km, DistanceUnit.KILOMETERS);
    }

    // Conversions
    public double inMiles() {
        return unit == DistanceUnit.MILES ? value : value * 0.621371;
    }

    public double inKilometers() {
        return unit == DistanceUnit.KILOMETERS ? value : value * 1.60934;
    }

    // Travel time estimates
    public Duration estimatedFlightTime() {
        // Rough estimate: 500 mph cruising + 1 hour for takeoff/landing
        return Duration.ofMinutes((long) (inMiles() / 500 * 60) + 60);
    }

    // Fatigue impact
    public TravelFatigueLevel getFatigueLevel() {
        double miles = inMiles();
        if (miles < 500) return TravelFatigueLevel.MINIMAL;
        if (miles < 1000) return TravelFatigueLevel.LOW;
        if (miles < 1500) return TravelFatigueLevel.MODERATE;
        if (miles < 2500) return TravelFatigueLevel.HIGH;
        return TravelFatigueLevel.EXTREME;
    }
}
```

### 8. TravelRoute (Entity)

Represents travel between two locations.

**Location**: `domain/entity/TravelRoute.java`

```java
public class TravelRoute {

    private UUID id;
    private Stadium origin;
    private Stadium destination;

    // Distance and time
    private Distance distance;
    private Duration estimatedTravelTime;
    private Integer timeZoneChange;         // Hours difference

    // Impact factors
    private TravelFatigueLevel fatigueLevel;
    private Double performanceModifier;     // Based on distance/timezone

    // Direction (for timezone adjustment)
    private TravelDirection direction;      // EAST, WEST, NORTH, SOUTH

    // Rest requirements
    private Integer recommendedRestDays;

    // Business methods
    public StatModifier getStatModifier();
    public boolean isCoastToCoast();
    public boolean crossesMultipleTimeZones();

    // Factory
    public static TravelRoute between(Stadium from, Stadium to);
}
```

**TravelFatigueLevel Enum**:
```java
public enum TravelFatigueLevel {
    MINIMAL(1.0, "Short trip, minimal impact"),
    LOW(0.98, "Regional travel, minor fatigue"),
    MODERATE(0.95, "Cross-country, noticeable fatigue"),
    HIGH(0.92, "Long distance, significant fatigue"),
    EXTREME(0.88, "International/max distance");

    private final double performanceModifier;
    private final String description;
}
```

### 9. TimeZoneRegion (Value Object)

Time zone information for scheduling.

**Location**: `domain/model/TimeZoneRegion.java`

```java
public class TimeZoneRegion {

    private final String zoneId;            // "America/New_York"
    private final String displayName;       // "Eastern Time"
    private final String abbreviation;      // "ET"
    private final Integer utcOffset;        // Hours from UTC (standard time)

    // NFL scheduling
    private LocalTime typicalGameTime;      // 1:00 PM local

    // Factory for NFL time zones
    public static TimeZoneRegion eastern();
    public static TimeZoneRegion central();
    public static TimeZoneRegion mountain();
    public static TimeZoneRegion pacific();
    public static TimeZoneRegion london();  // International games

    // Methods
    public int hoursDifference(TimeZoneRegion other);
    public LocalDateTime toLocal(Instant instant);
    public boolean isEastOf(TimeZoneRegion other);
}
```

---

## NFL Stadium Data

### Predefined Stadiums

```java
public class NFLStadiums {

    public static List<Stadium> all() {
        return List.of(
            // AFC East
            stadium("GILLETTE", "Gillette Stadium", "NE",
                42.0909, -71.2643, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.ARTIFICIAL_TURF, 65878, 262),

            stadium("HIGHMARK", "Highmark Stadium", "BUF",
                42.7738, -78.7870, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.ARTIFICIAL_TURF, 71608, 597),

            stadium("METLIFE", "MetLife Stadium", "NYJ", // Also NYG
                40.8135, -74.0745, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.ARTIFICIAL_TURF, 82500, 30),

            stadium("HARD_ROCK", "Hard Rock Stadium", "MIA",
                25.9580, -80.2389, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 65326, 10),

            // AFC North
            stadium("FIRSTENERGY", "Cleveland Browns Stadium", "CLE",
                41.5061, -81.6995, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 67895, 583),

            stadium("HEINZ", "Acrisure Stadium", "PIT",
                40.4468, -80.0158, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 68400, 730),

            stadium("PAYCOR", "Paycor Stadium", "CIN",
                39.0955, -84.5161, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.ARTIFICIAL_TURF, 65515, 490),

            stadium("MT_BANK", "M&T Bank Stadium", "BAL",
                39.2780, -76.6227, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 71008, 33),

            // AFC South
            stadium("NISSAN", "Nissan Stadium", "TEN",
                36.1665, -86.7713, "America/Chicago",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 69143, 400),

            stadium("LUCAS_OIL", "Lucas Oil Stadium", "IND",
                39.7601, -86.1639, "America/New_York",
                VenueType.RETRACTABLE, SurfaceType.ARTIFICIAL_TURF, 67000, 715),

            stadium("NRG", "NRG Stadium", "HOU",
                29.6847, -95.4107, "America/Chicago",
                VenueType.RETRACTABLE, SurfaceType.ARTIFICIAL_TURF, 72220, 50),

            stadium("TIAA_BANK", "EverBank Stadium", "JAX",
                30.3239, -81.6373, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 67814, 10),

            // AFC West
            stadium("ARROWHEAD", "GEHA Field at Arrowhead Stadium", "KC",
                39.0489, -94.4839, "America/Chicago",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 76416, 820),

            stadium("ALLEGIANT", "Allegiant Stadium", "LV",
                36.0909, -115.1833, "America/Los_Angeles",
                VenueType.DOME, SurfaceType.NATURAL_GRASS, 65000, 2030),

            stadium("SOFI", "SoFi Stadium", "LAC", // Also LAR
                33.9535, -118.3392, "America/Los_Angeles",
                VenueType.DOME, SurfaceType.ARTIFICIAL_TURF, 70240, 118),

            stadium("EMPOWER", "Empower Field at Mile High", "DEN",
                39.7439, -105.0201, "America/Denver",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 76125, 5280),

            // NFC East
            stadium("LINCOLN", "Lincoln Financial Field", "PHI",
                39.9008, -75.1675, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 69796, 39),

            stadium("ATT", "AT&T Stadium", "DAL",
                32.7473, -97.0945, "America/Chicago",
                VenueType.RETRACTABLE, SurfaceType.ARTIFICIAL_TURF, 80000, 561),

            stadium("FEDEX", "Commanders Field", "WAS",
                38.9076, -76.8645, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 67617, 200),

            // NFC North
            stadium("SOLDIER", "Soldier Field", "CHI",
                41.8623, -87.6167, "America/Chicago",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 61500, 596),

            stadium("LAMBEAU", "Lambeau Field", "GB",
                44.5013, -88.0622, "America/Chicago",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 81441, 640),

            stadium("US_BANK", "U.S. Bank Stadium", "MIN",
                44.9737, -93.2575, "America/Chicago",
                VenueType.DOME, SurfaceType.ARTIFICIAL_TURF, 66860, 815),

            stadium("FORD", "Ford Field", "DET",
                42.3400, -83.0456, "America/New_York",
                VenueType.DOME, SurfaceType.ARTIFICIAL_TURF, 65000, 600),

            // NFC South
            stadium("MERCEDES", "Mercedes-Benz Stadium", "ATL",
                33.7554, -84.4010, "America/New_York",
                VenueType.RETRACTABLE, SurfaceType.ARTIFICIAL_TURF, 71000, 1050),

            stadium("SUPERDOME", "Caesars Superdome", "NO",
                29.9511, -90.0812, "America/Chicago",
                VenueType.DOME, SurfaceType.ARTIFICIAL_TURF, 73000, 3),

            stadium("BOA", "Bank of America Stadium", "CAR",
                35.2258, -80.8528, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 75419, 751),

            stadium("RAYMOND", "Raymond James Stadium", "TB",
                27.9759, -82.5033, "America/New_York",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 65890, 42),

            // NFC West
            stadium("LEVI", "Levi's Stadium", "SF",
                37.4033, -121.9694, "America/Los_Angeles",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 68500, 43),

            stadium("STATE_FARM", "State Farm Stadium", "ARI",
                33.5276, -112.2626, "America/Phoenix",
                VenueType.RETRACTABLE, SurfaceType.NATURAL_GRASS, 63400, 1070),

            stadium("LUMEN", "Lumen Field", "SEA",
                47.5952, -122.3316, "America/Los_Angeles",
                VenueType.OUTDOOR, SurfaceType.ARTIFICIAL_TURF, 68740, 20)
        );
    }

    public static Map<String, WeatherZone> teamWeatherZones() {
        return Map.of(
            "GB", WeatherZone.greatLakes(),
            "CHI", WeatherZone.greatLakes(),
            "BUF", WeatherZone.greatLakes(),
            "CLE", WeatherZone.greatLakes(),
            "NE", WeatherZone.northeast(),
            "NYJ", WeatherZone.northeast(),
            "NYG", WeatherZone.northeast(),
            "DEN", WeatherZone.mountain(),
            "MIA", WeatherZone.tropical(),
            "TB", WeatherZone.tropical(),
            "JAX", WeatherZone.subtropical()
            // ... etc
        );
    }
}
```

### Weather Zones

```java
public class NFLWeatherZones {

    public static WeatherZone greatLakes() {
        return WeatherZone.builder()
            .name("Great Lakes")
            .code("GREAT_LAKES")
            .climateType(ClimateType.CONTINENTAL)
            .monthlyProfile(12, MonthlyWeatherProfile.builder()
                .clearProbability(0.25)
                .cloudyProbability(0.35)
                .snowProbability(0.30)
                .rainProbability(0.10)
                .averageHigh(32)
                .averageLow(18)
                .averageWindSpeed(12)
                .build())
            .monthlyProfile(1, MonthlyWeatherProfile.builder()
                .clearProbability(0.20)
                .cloudyProbability(0.40)
                .snowProbability(0.35)
                .rainProbability(0.05)
                .averageHigh(28)
                .averageLow(14)
                .averageWindSpeed(14)
                .build())
            .build();
    }

    public static WeatherZone mountain() {
        return WeatherZone.builder()
            .name("Mountain/High Altitude")
            .code("MOUNTAIN")
            .climateType(ClimateType.SEMI_ARID)
            // Denver at 5280 ft - thin air affects kicking
            .monthlyProfile(12, MonthlyWeatherProfile.builder()
                .clearProbability(0.50)
                .cloudyProbability(0.25)
                .snowProbability(0.20)
                .rainProbability(0.05)
                .averageHigh(43)
                .averageLow(18)
                .averageWindSpeed(8)
                .build())
            .build();
    }

    public static WeatherZone tropical() {
        return WeatherZone.builder()
            .name("Tropical/South Florida")
            .code("TROPICAL")
            .climateType(ClimateType.TROPICAL)
            .monthlyProfile(12, MonthlyWeatherProfile.builder()
                .clearProbability(0.60)
                .cloudyProbability(0.20)
                .rainProbability(0.15)
                .stormProbability(0.05)
                .averageHigh(77)
                .averageLow(60)
                .averageHumidity(70)
                .build())
            .build();
    }
}
```

---

## Port Interfaces

### StadiumRepository

**Location**: `domain/port/StadiumRepository.java`

```java
public interface StadiumRepository {

    // Stadium CRUD
    Stadium save(Stadium stadium);
    Optional<Stadium> findById(UUID id);
    Optional<Stadium> findByCode(String code);
    Optional<Stadium> findByTeam(String teamAbbreviation);
    List<Stadium> findAll();

    // Queries
    List<Stadium> findByVenueType(VenueType type);
    List<Stadium> findByWeatherZone(String weatherZoneCode);
    List<Stadium> findOutdoorStadiums();
    List<Stadium> findDomeStadiums();

    // Weather zones
    Optional<WeatherZone> findWeatherZone(String code);
    List<WeatherZone> findAllWeatherZones();
}
```

### WeatherService

**Location**: `domain/port/WeatherService.java`

```java
public interface WeatherService {

    /**
     * Generates weather conditions for a game.
     */
    WeatherConditions generateGameWeather(
        Stadium stadium,
        Integer month,
        Random random
    );

    /**
     * Gets historical weather for a specific date/location.
     */
    WeatherConditions getHistoricalWeather(
        Stadium stadium,
        LocalDate date
    );

    /**
     * Gets weather probabilities for a location/month.
     */
    WeatherProbabilities getWeatherProbabilities(
        Stadium stadium,
        Integer month
    );

    /**
     * Calculates stat modifiers for weather conditions.
     */
    StatModifiers calculateWeatherModifiers(
        WeatherConditions conditions,
        VenueType venueType
    );
}
```

### TravelService

**Location**: `domain/port/TravelService.java`

```java
public interface TravelService {

    /**
     * Calculates travel route between stadiums.
     */
    TravelRoute calculateRoute(Stadium from, Stadium to);

    /**
     * Gets performance modifier for travel.
     */
    Double getTravelFatigueModifier(TravelRoute route, int daysSinceTravel);

    /**
     * Gets all routes from a stadium.
     */
    List<TravelRoute> getRoutesFrom(Stadium origin);

    /**
     * Finds longest travel routes in league.
     */
    List<TravelRoute> getLongestRoutes(int limit);
}
```

---

## Integration with Other Systems

### World Event Integration

Weather events are generated based on location:

```java
@Component
public class LocationAwareEventGenerator {

    private final StadiumRepository stadiumRepository;
    private final WeatherService weatherService;

    public List<WorldEvent> generateWeatherEventsForWeek(
        UUID simulationRunId,
        Integer nflWeek,
        Integer month
    ) {
        List<WorldEvent> events = new ArrayList<>();

        for (Stadium stadium : stadiumRepository.findOutdoorStadiums()) {
            WeatherConditions conditions = weatherService.generateGameWeather(
                stadium, month, new Random()
            );

            if (conditions.getSeverity() != WeatherSeverity.NORMAL) {
                WorldEvent weatherEvent = createWeatherEvent(
                    simulationRunId,
                    stadium,
                    conditions,
                    nflWeek
                );
                events.add(weatherEvent);
            }
        }

        return events;
    }
}
```

### Simulation Core Integration

Travel fatigue affects player performance:

```java
@Component
public class TravelAwareStatsGenerator {

    private final TravelService travelService;

    public List<StatModifier> getTravelModifiers(
        String teamAbbreviation,
        UUID awayGameId,
        Integer daysSinceTravel
    ) {
        Stadium homeStadium = getHomeStadium(teamAbbreviation);
        Stadium awayStadium = getGameStadium(awayGameId);

        TravelRoute route = travelService.calculateRoute(homeStadium, awayStadium);
        Double modifier = travelService.getTravelFatigueModifier(route, daysSinceTravel);

        return List.of(
            StatModifier.multiply(StatCategory.ALL_STATS, modifier)
        );
    }
}
```

---

## API Endpoints

### Stadium Endpoints

```
GET    /api/v1/stadiums
       List all NFL stadiums

GET    /api/v1/stadiums/{code}
       Get stadium by code

GET    /api/v1/stadiums/team/{teamAbbr}
       Get stadium for team

GET    /api/v1/stadiums/outdoor
       List outdoor stadiums

GET    /api/v1/stadiums/domes
       List dome stadiums
```

### Weather Zone Endpoints

```
GET    /api/v1/weather-zones
       List all weather zones

GET    /api/v1/weather-zones/{code}
       Get weather zone details

GET    /api/v1/weather-zones/{code}/month/{month}
       Get monthly weather profile
```

### Distance/Travel Endpoints

```
GET    /api/v1/travel/distance?from={code}&to={code}
       Get distance between stadiums

GET    /api/v1/travel/route?from={code}&to={code}
       Get full travel route with fatigue

GET    /api/v1/travel/longest-routes
       Get longest travel routes in NFL
```

### Weather Simulation Endpoints

```
POST   /api/v1/simulations/{runId}/weather/generate
       Generate weather for week

GET    /api/v1/simulations/{runId}/weather/week/{week}
       Get weather conditions for week
```

---

## MongoDB Collections

### stadiums Collection

```javascript
{
  _id: UUID,
  name: String,
  code: String,
  primaryTeamAbbreviation: String,
  tenantTeams: [String],

  coordinates: {
    latitude: Double,
    longitude: Double
  },

  address: {
    street: String,
    city: String,
    state: String,
    postalCode: String,
    country: String
  },

  timeZone: String,
  weatherZoneCode: String,

  venueType: String,              // OUTDOOR, DOME, RETRACTABLE
  surfaceType: String,            // GRASS, TURF, HYBRID
  capacity: Number,
  elevation: Number,

  homeFieldAdvantage: Double,
  noiseFactor: Double,
  weatherExposure: Double,

  openedYear: Number,
  isActive: Boolean,
  updatedAt: ISODate
}

// Indexes
db.stadiums.createIndex({ code: 1 }, { unique: true })
db.stadiums.createIndex({ primaryTeamAbbreviation: 1 })
db.stadiums.createIndex({ venueType: 1 })
db.stadiums.createIndex({ weatherZoneCode: 1 })
```

### weather_zones Collection

```javascript
{
  _id: UUID,
  name: String,
  code: String,
  climateType: String,

  bounds: {
    northLat: Double,
    southLat: Double,
    eastLon: Double,
    westLon: Double
  },

  monthlyProfiles: {
    "1": {
      clearProbability: Double,
      cloudyProbability: Double,
      rainProbability: Double,
      snowProbability: Double,
      stormProbability: Double,
      calmWindProbability: Double,
      averageWindSpeed: Double,
      averageHigh: Double,
      averageLow: Double,
      averageHumidity: Double
    },
    // ... months 2-12
  },

  annualPrecipitationInches: Double,
  annualSnowfallInches: Double
}

// Indexes
db.weather_zones.createIndex({ code: 1 }, { unique: true })
db.weather_zones.createIndex({ climateType: 1 })
```

### travel_routes Collection (Cached)

```javascript
{
  _id: UUID,
  originCode: String,
  destinationCode: String,

  distanceMiles: Double,
  estimatedTravelMinutes: Number,
  timeZoneChange: Number,

  fatigueLevel: String,
  performanceModifier: Double,
  direction: String,
  recommendedRestDays: Number,

  calculatedAt: ISODate
}

// Indexes
db.travel_routes.createIndex({ originCode: 1, destinationCode: 1 }, { unique: true })
db.travel_routes.createIndex({ distanceMiles: -1 })
```

---

## Feature File

**Location**: `features/ffl-location-entities.feature`

```gherkin
Feature: Location Entity Curation
  As a simulation administrator
  I want to manage stadium and location data
  So that simulations include realistic geographic factors

  Background:
    Given NFL stadium data is loaded

  # Stadium Data

  Scenario: Get stadium for team
    When I request stadium for team "KC"
    Then I receive stadium:
      | Name     | GEHA Field at Arrowhead Stadium |
      | Type     | OUTDOOR                         |
      | Surface  | NATURAL_GRASS                   |
      | Capacity | 76416                           |
      | Elevation| 820 ft                          |

  Scenario: List outdoor stadiums
    When I request all outdoor stadiums
    Then I receive stadiums exposed to weather
    And dome stadiums are not included

  Scenario: Identify high altitude venue
    When I check if Denver stadium is high altitude
    Then the result is true
    And elevation is 5280 feet
    And kicking stats should receive altitude modifier

  # Weather Zones

  Scenario: Get weather zone for stadium
    Given Lambeau Field is in weather zone "GREAT_LAKES"
    When I query the weather zone
    Then I receive climate type "CONTINENTAL"
    And snow probability for December is high

  Scenario: Generate weather for outdoor game
    Given a game at Buffalo in December
    When weather is generated
    Then conditions may include:
      | Snow        | 30% chance |
      | Cold        | Average 28F|
      | High winds  | 15% chance |

  Scenario: Dome stadium ignores weather
    Given a game at US Bank Stadium (dome)
    When weather is generated
    Then conditions are always ideal
    And no weather modifiers apply

  # Weather Effects

  Scenario: Rain reduces passing stats
    Given weather conditions:
      | Type        | RAIN      |
      | Intensity   | Moderate  |
      | Wind        | 10 mph    |
    When stat modifiers are calculated
    Then passing stats receive -10% modifier
    And rushing stats are unaffected

  Scenario: Snow has major impact
    Given weather conditions:
      | Type        | HEAVY_SNOW|
      | Temperature | 25F       |
      | Visibility  | 0.5 miles |
    When stat modifiers are calculated
    Then passing stats receive -35% modifier
    And kicking stats receive -25% modifier
    And injury probability increases

  Scenario: Extreme cold affects all stats
    Given weather conditions:
      | Type        | CLEAR     |
      | Temperature | 5F        |
      | Wind chill  | -15F      |
    When stat modifiers are calculated
    Then all offensive stats receive -15% modifier
    And fumble probability increases

  # Travel and Fatigue

  Scenario: Calculate travel distance
    When I calculate distance from Seattle to Miami
    Then distance is approximately 2735 miles
    And fatigue level is "EXTREME"
    And performance modifier is 0.88

  Scenario: Coast-to-coast travel impact
    Given team traveled from LA to NY (2450 miles)
    And they played 3 days after arrival
    When travel fatigue is calculated
    Then all players receive fatigue modifier
    And modifier is approximately -5%

  Scenario: Short travel minimal impact
    Given team traveled from Philadelphia to NY (95 miles)
    When travel fatigue is calculated
    Then fatigue level is "MINIMAL"
    And no performance modifier applies

  Scenario: Time zone change fatigue
    Given team traveled west to east (3 time zones)
    When travel fatigue is calculated
    Then additional modifier for timezone adjustment
    And eastward travel is harder than westward

  # Home Field Advantage

  Scenario: High noise stadium has stronger HFA
    Given Arrowhead Stadium has noise factor 1.2
    When home field advantage is calculated
    Then HFA modifier is higher than average
    And visiting team receives crowd noise penalty

  Scenario: Dome neutralizes weather HFA
    Given outdoor team plays at dome stadium
    When environmental factors are calculated
    Then weather-related advantages don't apply
    And only crowd factors remain

  # Integration

  Scenario: Weather event created from location
    Given a Week 15 game at Green Bay
    When simulation generates weather
    And conditions are HEAVY_SNOW
    Then a weather WorldEvent is created
    And event affects all players in game
    And narrative reflects weather conditions
```

---

## Files to Create

### Domain Layer
- `domain/aggregate/Stadium.java`
- `domain/entity/WeatherZone.java`
- `domain/entity/TravelRoute.java`
- `domain/model/GeoCoordinates.java`
- `domain/model/Address.java`
- `domain/model/VenueType.java`
- `domain/model/SurfaceType.java`
- `domain/model/ClimateType.java`
- `domain/model/MonthlyWeatherProfile.java`
- `domain/model/WeatherConditions.java`
- `domain/model/WeatherType.java`
- `domain/model/WeatherSeverity.java`
- `domain/model/Distance.java`
- `domain/model/TravelFatigueLevel.java`
- `domain/model/TimeZoneRegion.java`
- `domain/model/FieldCondition.java`
- `domain/port/StadiumRepository.java`
- `domain/port/WeatherService.java`
- `domain/port/TravelService.java`

### Application Layer
- `application/usecase/GetStadiumUseCase.java`
- `application/usecase/GenerateWeatherUseCase.java`
- `application/usecase/CalculateTravelUseCase.java`
- `application/service/LocationAwareEventGenerator.java`
- `application/service/TravelAwareStatsGenerator.java`
- `application/dto/StadiumDTO.java`
- `application/dto/WeatherConditionsDTO.java`
- `application/dto/TravelRouteDTO.java`

### Infrastructure Layer
- `infrastructure/adapter/rest/StadiumController.java`
- `infrastructure/adapter/rest/WeatherZoneController.java`
- `infrastructure/adapter/rest/TravelController.java`
- `infrastructure/adapter/persistence/document/StadiumDocument.java`
- `infrastructure/adapter/persistence/document/WeatherZoneDocument.java`
- `infrastructure/adapter/persistence/document/TravelRouteDocument.java`
- `infrastructure/adapter/persistence/StadiumRepositoryImpl.java`
- `infrastructure/location/NFLStadiums.java`
- `infrastructure/location/NFLWeatherZones.java`
- `infrastructure/location/DefaultWeatherService.java`
- `infrastructure/location/DefaultTravelService.java`

### Feature File
- `features/ffl-location-entities.feature`

---

## Implementation Priority

### Phase 1: Core Location Model
1. Stadium aggregate and repository
2. GeoCoordinates and Address value objects
3. VenueType and SurfaceType enums
4. NFL stadium data seeding

### Phase 2: Weather System
1. WeatherZone entity
2. WeatherConditions value object
3. MonthlyWeatherProfile
4. WeatherService implementation
5. Stat modifiers for weather

### Phase 3: Travel System
1. Distance value object
2. TravelRoute entity
3. TravelService implementation
4. Fatigue calculations

### Phase 4: Integration
1. World Event weather generation
2. Simulation Core modifiers
3. API endpoints
4. Narrative weather descriptions

---

**Document Status**: Ready for Implementation
**Created**: 2025-12-29
**Ticket**: ANIMA-1043
