package com.ffl.playoffs.infrastructure.location;

import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.entity.WeatherZone;
import com.ffl.playoffs.domain.model.MonthlyWeatherProfile;
import com.ffl.playoffs.domain.model.VenueType;
import com.ffl.playoffs.domain.model.WeatherConditions;
import com.ffl.playoffs.domain.model.WeatherSeverity;
import com.ffl.playoffs.domain.port.StadiumRepository;
import com.ffl.playoffs.domain.port.WeatherService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;
import java.util.Random;

/**
 * Default implementation of WeatherService.
 */
@Service
@RequiredArgsConstructor
public class DefaultWeatherService implements WeatherService {

    private final StadiumRepository stadiumRepository;

    @Override
    public WeatherConditions generateGameWeather(Stadium stadium, Integer month, Random random) {
        // Dome stadiums always have ideal conditions
        if (stadium.isDome()) {
            return WeatherConditions.ideal();
        }

        // Get weather zone for this stadium
        Optional<WeatherZone> zoneOpt = stadiumRepository.findWeatherZone(stadium.getWeatherZoneCode());

        if (zoneOpt.isEmpty()) {
            // Default weather if no zone found
            return WeatherConditions.defaultConditions();
        }

        WeatherZone zone = zoneOpt.get();
        WeatherConditions conditions = zone.generateWeather(month, random);

        // For retractable roofs, reduce weather severity
        if (stadium.getVenueType() == VenueType.RETRACTABLE) {
            conditions = moderateForRetractableRoof(conditions, random);
        }

        return conditions;
    }

    @Override
    public WeatherConditions getHistoricalWeather(Stadium stadium, LocalDate date) {
        // For historical weather, generate based on the month
        // In a real implementation, this would query historical data
        return generateGameWeather(stadium, date.getMonthValue(), new Random(date.toEpochDay()));
    }

    @Override
    public MonthlyWeatherProfile getWeatherProfile(Stadium stadium, Integer month) {
        Optional<WeatherZone> zoneOpt = stadiumRepository.findWeatherZone(stadium.getWeatherZoneCode());

        if (zoneOpt.isEmpty()) {
            return MonthlyWeatherProfile.builder()
                    .month(month)
                    .build();
        }

        return zoneOpt.get().getWeatherProfile(month);
    }

    @Override
    public WeatherStatModifiers calculateWeatherModifiers(WeatherConditions conditions, VenueType venueType) {
        // Dome stadiums have no weather impact
        if (venueType == VenueType.DOME) {
            return WeatherStatModifiers.neutral();
        }

        // Retractable roofs have reduced impact
        double exposureFactor = venueType == VenueType.RETRACTABLE ? 0.5 : 1.0;

        double passingMod = 1.0 + (conditions.getPassingModifier() - 1.0) * exposureFactor;
        double rushingMod = 1.0 + (conditions.getRushingModifier() - 1.0) * exposureFactor;
        double kickingMod = 1.0 + (conditions.getKickingModifier() - 1.0) * exposureFactor;
        double injuryMod = 1.0 + (conditions.getInjuryRiskModifier() - 1.0) * exposureFactor;
        double turnoverMod = 1.0 + (conditions.getTurnoverModifier() - 1.0) * exposureFactor;

        return new WeatherStatModifiers(
                passingMod,
                rushingMod,
                kickingMod,
                injuryMod,
                turnoverMod
        );
    }

    @Override
    public boolean isGameThreateningWeather(WeatherConditions conditions) {
        return conditions.getSeverity() == WeatherSeverity.EXTREME ||
               (conditions.getLightning() != null && conditions.getLightning());
    }

    /**
     * Moderate weather conditions for retractable roof stadiums.
     * Assumes roof is closed for severe conditions.
     */
    private WeatherConditions moderateForRetractableRoof(WeatherConditions conditions, Random random) {
        // If conditions are severe, assume roof is closed
        if (conditions.getSeverity() == WeatherSeverity.SEVERE ||
            conditions.getSeverity() == WeatherSeverity.EXTREME) {
            return WeatherConditions.ideal();
        }

        // For moderate conditions, 50% chance roof is closed
        if (conditions.getSeverity() == WeatherSeverity.MODERATE && random.nextBoolean()) {
            return WeatherConditions.ideal();
        }

        return conditions;
    }
}
