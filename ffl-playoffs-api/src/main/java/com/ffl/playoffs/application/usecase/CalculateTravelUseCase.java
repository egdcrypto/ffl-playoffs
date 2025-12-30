package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.TravelRouteDTO;
import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.entity.TravelRoute;
import com.ffl.playoffs.domain.port.StadiumRepository;
import com.ffl.playoffs.domain.port.TravelService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Use case for calculating travel routes and fatigue.
 */
@Service
@RequiredArgsConstructor
public class CalculateTravelUseCase {

    private final StadiumRepository stadiumRepository;
    private final TravelService travelService;

    /**
     * Calculates travel route between two stadiums.
     *
     * @param fromCode Origin stadium code
     * @param toCode   Destination stadium code
     * @return Travel route DTO
     */
    public Optional<TravelRouteDTO> calculateRoute(String fromCode, String toCode) {
        Optional<Stadium> fromStadium = stadiumRepository.findByCode(fromCode);
        Optional<Stadium> toStadium = stadiumRepository.findByCode(toCode);

        if (fromStadium.isEmpty() || toStadium.isEmpty()) {
            return Optional.empty();
        }

        TravelRoute route = travelService.calculateRoute(fromStadium.get(), toStadium.get());
        return Optional.of(TravelRouteDTO.fromDomain(route));
    }

    /**
     * Calculates travel between teams' home stadiums.
     */
    public Optional<TravelRouteDTO> calculateTeamTravel(
            String fromTeamAbbr,
            String toTeamAbbr
    ) {
        Optional<Stadium> fromStadium = stadiumRepository.findByTeam(fromTeamAbbr);
        Optional<Stadium> toStadium = stadiumRepository.findByTeam(toTeamAbbr);

        if (fromStadium.isEmpty() || toStadium.isEmpty()) {
            return Optional.empty();
        }

        TravelRoute route = travelService.calculateRoute(fromStadium.get(), toStadium.get());
        return Optional.of(TravelRouteDTO.fromDomain(route));
    }

    /**
     * Gets travel fatigue modifier based on days since travel.
     */
    public double getTravelFatigueModifier(
            String fromCode,
            String toCode,
            int daysSinceTravel
    ) {
        Optional<Stadium> fromStadium = stadiumRepository.findByCode(fromCode);
        Optional<Stadium> toStadium = stadiumRepository.findByCode(toCode);

        if (fromStadium.isEmpty() || toStadium.isEmpty()) {
            return 1.0; // No penalty if stadiums not found
        }

        TravelRoute route = travelService.calculateRoute(fromStadium.get(), toStadium.get());
        return travelService.getTravelFatigueModifier(route, daysSinceTravel);
    }

    /**
     * Gets all routes from a specific stadium.
     */
    public List<TravelRouteDTO> getRoutesFromStadium(String stadiumCode) {
        Optional<Stadium> stadiumOpt = stadiumRepository.findByCode(stadiumCode);
        if (stadiumOpt.isEmpty()) {
            return List.of();
        }

        return travelService.getRoutesFrom(stadiumOpt.get()).stream()
                .map(TravelRouteDTO::fromDomain)
                .toList();
    }

    /**
     * Gets all routes from a team's home stadium.
     */
    public List<TravelRouteDTO> getRoutesForTeam(String teamAbbreviation) {
        Optional<Stadium> stadiumOpt = stadiumRepository.findByTeam(teamAbbreviation);
        if (stadiumOpt.isEmpty()) {
            return List.of();
        }

        return travelService.getRoutesFrom(stadiumOpt.get()).stream()
                .map(TravelRouteDTO::fromDomain)
                .toList();
    }

    /**
     * Gets the longest travel routes in the NFL.
     */
    public List<TravelRouteDTO> getLongestRoutes(int limit) {
        return travelService.getLongestRoutes(limit).stream()
                .map(TravelRouteDTO::fromDomain)
                .toList();
    }

    /**
     * Gets coast-to-coast routes (3+ timezone changes).
     */
    public List<TravelRouteDTO> getCoastToCoastRoutes() {
        return travelService.getCoastToCoastRoutes().stream()
                .map(TravelRouteDTO::fromDomain)
                .toList();
    }

    /**
     * Gets travel difficulty score for a route.
     */
    public int getTravelDifficultyScore(String fromCode, String toCode) {
        Optional<Stadium> fromStadium = stadiumRepository.findByCode(fromCode);
        Optional<Stadium> toStadium = stadiumRepository.findByCode(toCode);

        if (fromStadium.isEmpty() || toStadium.isEmpty()) {
            return 0;
        }

        TravelRoute route = travelService.calculateRoute(fromStadium.get(), toStadium.get());
        return travelService.getTravelDifficultyScore(route);
    }

    /**
     * Gets recommended rest days for a route.
     */
    public int getRecommendedRestDays(String fromCode, String toCode) {
        Optional<Stadium> fromStadium = stadiumRepository.findByCode(fromCode);
        Optional<Stadium> toStadium = stadiumRepository.findByCode(toCode);

        if (fromStadium.isEmpty() || toStadium.isEmpty()) {
            return 0;
        }

        TravelRoute route = travelService.calculateRoute(fromStadium.get(), toStadium.get());
        return travelService.getRecommendedRestDays(route);
    }
}
