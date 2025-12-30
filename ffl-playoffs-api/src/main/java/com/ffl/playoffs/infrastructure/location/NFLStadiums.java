package com.ffl.playoffs.infrastructure.location;

import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.model.SurfaceType;
import com.ffl.playoffs.domain.model.VenueType;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Static NFL stadium data provider.
 */
public final class NFLStadiums {

    private NFLStadiums() {
    }

    /**
     * Returns all 30 NFL stadiums (32 teams, 2 shared venues).
     */
    public static List<Stadium> all() {
        List<Stadium> stadiums = new ArrayList<>();

        // AFC East
        stadiums.add(stadium("GILLETTE", "Gillette Stadium", "NE",
                42.0909, -71.2643, "America/New_York", "NORTHEAST",
                VenueType.OUTDOOR, SurfaceType.ARTIFICIAL_TURF, 65878, 262));

        stadiums.add(stadium("HIGHMARK", "Highmark Stadium", "BUF",
                42.7738, -78.7870, "America/New_York", "GREAT_LAKES",
                VenueType.OUTDOOR, SurfaceType.ARTIFICIAL_TURF, 71608, 597));

        Stadium metlife = stadium("METLIFE", "MetLife Stadium", "NYJ",
                40.8135, -74.0745, "America/New_York", "NORTHEAST",
                VenueType.OUTDOOR, SurfaceType.ARTIFICIAL_TURF, 82500, 30);
        metlife.addTenantTeam("NYG");
        stadiums.add(metlife);

        stadiums.add(stadium("HARD_ROCK", "Hard Rock Stadium", "MIA",
                25.9580, -80.2389, "America/New_York", "TROPICAL",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 65326, 10));

        // AFC North
        stadiums.add(stadium("HUNTINGTON", "Huntington Bank Field", "CLE",
                41.5061, -81.6995, "America/New_York", "GREAT_LAKES",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 67895, 583));

        stadiums.add(stadium("ACRISURE", "Acrisure Stadium", "PIT",
                40.4468, -80.0158, "America/New_York", "GREAT_LAKES",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 68400, 730));

        stadiums.add(stadium("PAYCOR", "Paycor Stadium", "CIN",
                39.0955, -84.5161, "America/New_York", "MIDWEST",
                VenueType.OUTDOOR, SurfaceType.ARTIFICIAL_TURF, 65515, 490));

        stadiums.add(stadium("MT_BANK", "M&T Bank Stadium", "BAL",
                39.2780, -76.6227, "America/New_York", "MID_ATLANTIC",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 71008, 33));

        // AFC South
        stadiums.add(stadium("NISSAN", "Nissan Stadium", "TEN",
                36.1665, -86.7713, "America/Chicago", "SOUTHEAST",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 69143, 400));

        stadiums.add(stadium("LUCAS_OIL", "Lucas Oil Stadium", "IND",
                39.7601, -86.1639, "America/New_York", "MIDWEST",
                VenueType.RETRACTABLE, SurfaceType.ARTIFICIAL_TURF, 67000, 715));

        stadiums.add(stadium("NRG", "NRG Stadium", "HOU",
                29.6847, -95.4107, "America/Chicago", "GULF_COAST",
                VenueType.RETRACTABLE, SurfaceType.ARTIFICIAL_TURF, 72220, 50));

        stadiums.add(stadium("EVERBANK", "EverBank Stadium", "JAX",
                30.3239, -81.6373, "America/New_York", "SUBTROPICAL",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 67814, 10));

        // AFC West
        stadiums.add(stadium("ARROWHEAD", "GEHA Field at Arrowhead Stadium", "KC",
                39.0489, -94.4839, "America/Chicago", "MIDWEST",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 76416, 820));

        stadiums.add(stadium("ALLEGIANT", "Allegiant Stadium", "LV",
                36.0909, -115.1833, "America/Los_Angeles", "DESERT",
                VenueType.DOME, SurfaceType.NATURAL_GRASS, 65000, 2030));

        Stadium sofi = stadium("SOFI", "SoFi Stadium", "LAC",
                33.9535, -118.3392, "America/Los_Angeles", "PACIFIC",
                VenueType.DOME, SurfaceType.ARTIFICIAL_TURF, 70240, 118);
        sofi.addTenantTeam("LAR");
        stadiums.add(sofi);

        stadiums.add(stadium("EMPOWER", "Empower Field at Mile High", "DEN",
                39.7439, -105.0201, "America/Denver", "MOUNTAIN",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 76125, 5280));

        // NFC East
        stadiums.add(stadium("LINCOLN", "Lincoln Financial Field", "PHI",
                39.9008, -75.1675, "America/New_York", "MID_ATLANTIC",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 69796, 39));

        stadiums.add(stadium("ATT", "AT&T Stadium", "DAL",
                32.7473, -97.0945, "America/Chicago", "SOUTH_CENTRAL",
                VenueType.RETRACTABLE, SurfaceType.ARTIFICIAL_TURF, 80000, 561));

        stadiums.add(stadium("NORTHWEST", "Northwest Stadium", "WAS",
                38.9076, -76.8645, "America/New_York", "MID_ATLANTIC",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 67617, 200));

        // NFC North
        stadiums.add(stadium("SOLDIER", "Soldier Field", "CHI",
                41.8623, -87.6167, "America/Chicago", "GREAT_LAKES",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 61500, 596));

        stadiums.add(stadium("LAMBEAU", "Lambeau Field", "GB",
                44.5013, -88.0622, "America/Chicago", "GREAT_LAKES",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 81441, 640));

        stadiums.add(stadium("US_BANK", "U.S. Bank Stadium", "MIN",
                44.9737, -93.2575, "America/Chicago", "GREAT_LAKES",
                VenueType.DOME, SurfaceType.ARTIFICIAL_TURF, 66860, 815));

        stadiums.add(stadium("FORD", "Ford Field", "DET",
                42.3400, -83.0456, "America/New_York", "GREAT_LAKES",
                VenueType.DOME, SurfaceType.ARTIFICIAL_TURF, 65000, 600));

        // NFC South
        stadiums.add(stadium("MERCEDES", "Mercedes-Benz Stadium", "ATL",
                33.7554, -84.4010, "America/New_York", "SOUTHEAST",
                VenueType.RETRACTABLE, SurfaceType.ARTIFICIAL_TURF, 71000, 1050));

        stadiums.add(stadium("SUPERDOME", "Caesars Superdome", "NO",
                29.9511, -90.0812, "America/Chicago", "GULF_COAST",
                VenueType.DOME, SurfaceType.ARTIFICIAL_TURF, 73000, 3));

        stadiums.add(stadium("BOA", "Bank of America Stadium", "CAR",
                35.2258, -80.8528, "America/New_York", "SOUTHEAST",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 75419, 751));

        stadiums.add(stadium("RAYMOND", "Raymond James Stadium", "TB",
                27.9759, -82.5033, "America/New_York", "SUBTROPICAL",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 65890, 42));

        // NFC West
        stadiums.add(stadium("LEVI", "Levi's Stadium", "SF",
                37.4033, -121.9694, "America/Los_Angeles", "PACIFIC",
                VenueType.OUTDOOR, SurfaceType.NATURAL_GRASS, 68500, 43));

        stadiums.add(stadium("STATE_FARM", "State Farm Stadium", "ARI",
                33.5276, -112.2626, "America/Phoenix", "DESERT",
                VenueType.RETRACTABLE, SurfaceType.NATURAL_GRASS, 63400, 1070));

        stadiums.add(stadium("LUMEN", "Lumen Field", "SEA",
                47.5952, -122.3316, "America/Los_Angeles", "PACIFIC_NW",
                VenueType.OUTDOOR, SurfaceType.ARTIFICIAL_TURF, 68740, 20));

        return stadiums;
    }

    /**
     * Maps team abbreviations to their weather zone codes.
     */
    public static Map<String, String> teamWeatherZones() {
        return Map.ofEntries(
                // Great Lakes
                Map.entry("GB", "GREAT_LAKES"),
                Map.entry("CHI", "GREAT_LAKES"),
                Map.entry("BUF", "GREAT_LAKES"),
                Map.entry("CLE", "GREAT_LAKES"),
                Map.entry("DET", "GREAT_LAKES"),
                Map.entry("MIN", "GREAT_LAKES"),
                Map.entry("PIT", "GREAT_LAKES"),

                // Northeast
                Map.entry("NE", "NORTHEAST"),
                Map.entry("NYJ", "NORTHEAST"),
                Map.entry("NYG", "NORTHEAST"),

                // Mid-Atlantic
                Map.entry("BAL", "MID_ATLANTIC"),
                Map.entry("PHI", "MID_ATLANTIC"),
                Map.entry("WAS", "MID_ATLANTIC"),

                // Midwest
                Map.entry("KC", "MIDWEST"),
                Map.entry("IND", "MIDWEST"),
                Map.entry("CIN", "MIDWEST"),

                // Mountain
                Map.entry("DEN", "MOUNTAIN"),

                // Desert
                Map.entry("LV", "DESERT"),
                Map.entry("ARI", "DESERT"),

                // Pacific
                Map.entry("LAC", "PACIFIC"),
                Map.entry("LAR", "PACIFIC"),
                Map.entry("SF", "PACIFIC"),

                // Pacific Northwest
                Map.entry("SEA", "PACIFIC_NW"),

                // Gulf Coast
                Map.entry("HOU", "GULF_COAST"),
                Map.entry("NO", "GULF_COAST"),

                // Southeast
                Map.entry("ATL", "SOUTHEAST"),
                Map.entry("TEN", "SOUTHEAST"),
                Map.entry("CAR", "SOUTHEAST"),

                // South Central
                Map.entry("DAL", "SOUTH_CENTRAL"),

                // Subtropical
                Map.entry("JAX", "SUBTROPICAL"),
                Map.entry("TB", "SUBTROPICAL"),

                // Tropical
                Map.entry("MIA", "TROPICAL")
        );
    }

    private static Stadium stadium(String code, String name, String team,
                                    double lat, double lon, String timeZone, String weatherZone,
                                    VenueType venueType, SurfaceType surfaceType,
                                    int capacity, int elevation) {
        Stadium stadium = Stadium.create(name, code, team, lat, lon, timeZone,
                venueType, surfaceType, capacity, elevation);
        stadium.setWeatherZoneCode(weatherZone);
        return stadium;
    }
}
