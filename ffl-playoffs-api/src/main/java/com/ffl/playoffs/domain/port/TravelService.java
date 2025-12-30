package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.entity.TravelRoute;

import java.util.List;

/**
 * Service port for travel calculations and route management.
 */
public interface TravelService {

    /**
     * Calculates travel route between two stadiums.
     *
     * @param from Origin stadium
     * @param to   Destination stadium
     * @return Travel route with distance, time, and fatigue calculations
     */
    TravelRoute calculateRoute(Stadium from, Stadium to);

    /**
     * Gets performance modifier for travel based on days since travel.
     *
     * @param route           The travel route taken
     * @param daysSinceTravel Days since the team traveled
     * @return Performance modifier (1.0 = no effect, less = negative impact)
     */
    Double getTravelFatigueModifier(TravelRoute route, int daysSinceTravel);

    /**
     * Gets all travel routes from an origin stadium to all other stadiums.
     *
     * @param origin The origin stadium
     * @return List of travel routes to all other stadiums
     */
    List<TravelRoute> getRoutesFrom(Stadium origin);

    /**
     * Finds the longest travel routes in the league.
     *
     * @param limit Maximum number of routes to return
     * @return List of longest routes, sorted by distance descending
     */
    List<TravelRoute> getLongestRoutes(int limit);

    /**
     * Finds routes that cross multiple time zones (3+).
     *
     * @return List of coast-to-coast style routes
     */
    List<TravelRoute> getCoastToCoastRoutes();

    /**
     * Gets the recommended rest days for a travel route.
     *
     * @param route The travel route
     * @return Recommended rest days before optimal performance
     */
    int getRecommendedRestDays(TravelRoute route);

    /**
     * Calculates cumulative fatigue for a road trip with multiple destinations.
     *
     * @param stadiums     Ordered list of stadiums (home, away1, away2, etc.)
     * @param daysBetween  Days between each leg
     * @return Cumulative fatigue modifier
     */
    Double calculateRoadTripFatigue(List<Stadium> stadiums, List<Integer> daysBetween);

    /**
     * Gets travel difficulty score (0-100) for a route.
     * Combines distance, timezone change, and direction factors.
     *
     * @param route The travel route
     * @return Difficulty score (higher = more difficult)
     */
    int getTravelDifficultyScore(TravelRoute route);
}
