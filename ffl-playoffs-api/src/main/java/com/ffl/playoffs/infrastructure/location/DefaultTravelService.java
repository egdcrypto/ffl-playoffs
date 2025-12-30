package com.ffl.playoffs.infrastructure.location;

import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.entity.TravelRoute;
import com.ffl.playoffs.domain.model.TravelFatigueLevel;
import com.ffl.playoffs.domain.port.StadiumRepository;
import com.ffl.playoffs.domain.port.TravelService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * Default implementation of TravelService.
 */
@Service
@RequiredArgsConstructor
public class DefaultTravelService implements TravelService {

    private final StadiumRepository stadiumRepository;

    @Override
    public TravelRoute calculateRoute(Stadium from, Stadium to) {
        return TravelRoute.between(from, to);
    }

    @Override
    public Double getTravelFatigueModifier(TravelRoute route, int daysSinceTravel) {
        return route.getAdjustedModifier(daysSinceTravel);
    }

    @Override
    public List<TravelRoute> getRoutesFrom(Stadium origin) {
        List<Stadium> allStadiums = stadiumRepository.findAll();
        List<TravelRoute> routes = new ArrayList<>();

        for (Stadium destination : allStadiums) {
            if (!destination.getCode().equals(origin.getCode())) {
                routes.add(TravelRoute.between(origin, destination));
            }
        }

        return routes;
    }

    @Override
    public List<TravelRoute> getLongestRoutes(int limit) {
        List<Stadium> allStadiums = stadiumRepository.findAll();
        List<TravelRoute> allRoutes = new ArrayList<>();

        // Generate all possible routes
        for (Stadium from : allStadiums) {
            for (Stadium to : allStadiums) {
                if (!from.getCode().equals(to.getCode())) {
                    allRoutes.add(TravelRoute.between(from, to));
                }
            }
        }

        // Sort by distance descending and return top N
        return allRoutes.stream()
                .sorted(Comparator.comparingDouble(r -> -r.getDistance().inMiles()))
                .limit(limit)
                .toList();
    }

    @Override
    public List<TravelRoute> getCoastToCoastRoutes() {
        List<Stadium> allStadiums = stadiumRepository.findAll();
        List<TravelRoute> coastToCoastRoutes = new ArrayList<>();

        for (Stadium from : allStadiums) {
            for (Stadium to : allStadiums) {
                if (!from.getCode().equals(to.getCode())) {
                    TravelRoute route = TravelRoute.between(from, to);
                    if (route.isCoastToCoast()) {
                        coastToCoastRoutes.add(route);
                    }
                }
            }
        }

        return coastToCoastRoutes;
    }

    @Override
    public int getRecommendedRestDays(TravelRoute route) {
        return route.getRecommendedRestDays();
    }

    @Override
    public Double calculateRoadTripFatigue(List<Stadium> stadiums, List<Integer> daysBetween) {
        if (stadiums.size() < 2) {
            return 1.0;
        }

        double cumulativeFatigue = 1.0;
        int totalDaysWithoutFullRest = 0;

        for (int i = 0; i < stadiums.size() - 1; i++) {
            TravelRoute route = TravelRoute.between(stadiums.get(i), stadiums.get(i + 1));
            int days = i < daysBetween.size() ? daysBetween.get(i) : 0;

            // Get the fatigue modifier for this leg
            double legFatigue = getTravelFatigueModifier(route, days);

            // If they didn't get full rest, accumulate fatigue
            if (days < route.getRecommendedRestDays()) {
                totalDaysWithoutFullRest += (route.getRecommendedRestDays() - days);
            }

            // Compound fatigue effects
            cumulativeFatigue *= legFatigue;
        }

        // Additional penalty for prolonged travel without rest
        if (totalDaysWithoutFullRest > 3) {
            cumulativeFatigue *= Math.max(0.85, 1.0 - totalDaysWithoutFullRest * 0.02);
        }

        return Math.max(0.7, cumulativeFatigue); // Floor at 30% penalty
    }

    @Override
    public int getTravelDifficultyScore(TravelRoute route) {
        int score = 0;

        // Distance component (0-40 points)
        double miles = route.getDistance().inMiles();
        if (miles > 2500) score += 40;
        else if (miles > 2000) score += 30;
        else if (miles > 1500) score += 20;
        else if (miles > 1000) score += 10;
        else if (miles > 500) score += 5;

        // Timezone component (0-30 points)
        int tzChange = Math.abs(route.getTimeZoneChange() != null ? route.getTimeZoneChange() : 0);
        score += tzChange * 10;

        // Direction component (0-15 points) - eastward is harder
        if (route.getDirection() != null && route.getDirection().isEastward() && tzChange > 0) {
            score += 15;
        }

        // Fatigue level component (0-15 points)
        TravelFatigueLevel fatigue = route.getFatigueLevel();
        score += switch (fatigue) {
            case EXTREME -> 15;
            case HIGH -> 12;
            case MODERATE -> 8;
            case LOW -> 4;
            case MINIMAL -> 0;
        };

        return Math.min(100, score);
    }
}
