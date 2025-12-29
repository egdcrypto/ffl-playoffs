package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.entity.EventTemplate;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.domain.port.WorldEventRepository;

import java.util.*;

/**
 * Domain service for generating random events based on configuration.
 */
public class EventGenerationService {

    private final WorldEventRepository eventRepository;
    private final Random random;

    public EventGenerationService(WorldEventRepository eventRepository) {
        this.eventRepository = eventRepository;
        this.random = new Random();
    }

    public EventGenerationService(WorldEventRepository eventRepository, Random random) {
        this.eventRepository = eventRepository;
        this.random = random;
    }

    /**
     * Generates random events for a simulation week.
     */
    public List<WorldEvent> generateWeeklyEvents(
            UUID simulationWorldId,
            Integer week,
            EventGenerationConfig config,
            List<PlayerInfo> players,
            List<GameInfo> games) {

        List<WorldEvent> events = new ArrayList<>();

        if (config.isSimulateInjuries()) {
            events.addAll(generateInjuryEvents(simulationWorldId, week, config, players));
        }

        if (config.isSimulateWeather()) {
            events.addAll(generateWeatherEvents(simulationWorldId, week, config, games));
        }

        if (config.isSimulateStreaks()) {
            events.addAll(generateStreakEvents(simulationWorldId, week, config, players));
        }

        return events;
    }

    /**
     * Generates injury events based on position probabilities.
     */
    private List<WorldEvent> generateInjuryEvents(
            UUID simulationWorldId,
            Integer week,
            EventGenerationConfig config,
            List<PlayerInfo> players) {

        List<WorldEvent> injuries = new ArrayList<>();
        EventTemplate minorTemplate = EventTemplate.minorInjury();
        EventTemplate majorTemplate = EventTemplate.majorInjury();

        for (PlayerInfo player : players) {
            double probability = getInjuryProbability(player.position());
            probability *= config.getInjuryMultiplier();

            if (random.nextDouble() < probability) {
                // Determine injury severity
                boolean isMajor = random.nextDouble() < 0.2; // 20% chance of major injury
                EventTemplate template = isMajor ? majorTemplate : minorTemplate;

                int duration = isMajor ?
                        2 + random.nextInt(4) : // 2-5 weeks
                        1 + random.nextInt(2);  // 1-2 weeks

                EventTarget target = EventTarget.player(player.nflPlayerId(), player.name());
                EventTiming timing = EventTiming.weekRange(week, week + duration - 1);

                WorldEvent injury = template.instantiate(target, timing);
                injury.setSimulationWorldId(simulationWorldId);
                injury.setSource(EventSource.RANDOM);

                injuries.add(injury);
            }
        }

        return injuries;
    }

    /**
     * Generates weather events for outdoor games.
     */
    private List<WorldEvent> generateWeatherEvents(
            UUID simulationWorldId,
            Integer week,
            EventGenerationConfig config,
            List<GameInfo> games) {

        List<WorldEvent> weatherEvents = new ArrayList<>();

        for (GameInfo game : games) {
            if (!game.isOutdoor()) {
                continue;
            }

            // Base weather probability varies by week (higher in late season)
            double weatherProb = 0.1 + (week > 12 ? 0.1 : 0);
            weatherProb *= config.getWeatherMultiplier();

            if (random.nextDouble() < weatherProb) {
                WorldEventType weatherType = selectRandomWeatherType(week);
                EventTemplate template = EventTemplate.weatherEvent(weatherType);

                EventTarget target = EventTarget.game(game.gameId(), game.description());
                EventTiming timing = EventTiming.forGame(game.gameId());

                WorldEvent weather = template.instantiate(target, timing);
                weather.setSimulationWorldId(simulationWorldId);
                weather.setSource(EventSource.RANDOM);
                weather.setStartWeek(week);
                weather.setEndWeek(week);

                weatherEvents.add(weather);
            }
        }

        return weatherEvents;
    }

    /**
     * Generates hot/cold streak events.
     */
    private List<WorldEvent> generateStreakEvents(
            UUID simulationWorldId,
            Integer week,
            EventGenerationConfig config,
            List<PlayerInfo> players) {

        List<WorldEvent> streaks = new ArrayList<>();
        EventTemplate hotTemplate = EventTemplate.hotStreak();
        EventTemplate coldTemplate = EventTemplate.coldStreak();

        for (PlayerInfo player : players) {
            double streakProb = 0.01 * config.getStreakMultiplier();

            if (random.nextDouble() < streakProb) {
                boolean isHot = random.nextBoolean();
                EventTemplate template = isHot ? hotTemplate : coldTemplate;

                int duration = 2 + random.nextInt(3); // 2-4 weeks

                EventTarget target = EventTarget.player(player.nflPlayerId(), player.name());
                EventTiming timing = EventTiming.weekRange(week, week + duration - 1);

                WorldEvent streak = template.instantiate(target, timing);
                streak.setSimulationWorldId(simulationWorldId);
                streak.setSource(EventSource.RANDOM);

                streaks.add(streak);
            }
        }

        return streaks;
    }

    /**
     * Gets base injury probability by position.
     */
    private double getInjuryProbability(Position position) {
        return switch (position) {
            case RB -> 0.03;        // Running backs get injured most
            case WR -> 0.025;
            case TE -> 0.02;
            case QB -> 0.015;
            case K -> 0.005;        // Kickers rarely get injured
            case DEF -> 0.02;
            default -> 0.02;
        };
    }

    /**
     * Selects a random weather type appropriate for the week.
     */
    private WorldEventType selectRandomWeatherType(int week) {
        if (week >= 14) {
            // Late season: snow and cold more likely
            int roll = random.nextInt(10);
            if (roll < 4) return WorldEventType.WEATHER_SNOW;
            if (roll < 7) return WorldEventType.WEATHER_COLD;
            if (roll < 9) return WorldEventType.WEATHER_WIND;
            return WorldEventType.WEATHER_RAIN;
        } else {
            // Earlier season: rain and wind more likely
            int roll = random.nextInt(10);
            if (roll < 5) return WorldEventType.WEATHER_RAIN;
            if (roll < 8) return WorldEventType.WEATHER_WIND;
            return WorldEventType.WEATHER_COLD;
        }
    }

    /**
     * Player info for event generation.
     */
    public record PlayerInfo(Long nflPlayerId, String name, Position position, String team) {}

    /**
     * Game info for event generation.
     */
    public record GameInfo(UUID gameId, String description, boolean isOutdoor, String homeTeam, String awayTeam) {}

    /**
     * Configuration for event generation.
     */
    public static class EventGenerationConfig {
        private boolean simulateInjuries = true;
        private boolean simulateWeather = true;
        private boolean simulateStreaks = true;
        private double injuryMultiplier = 1.0;
        private double weatherMultiplier = 1.0;
        private double streakMultiplier = 1.0;

        public static EventGenerationConfig defaults() {
            return new EventGenerationConfig();
        }

        public static EventGenerationConfig noEvents() {
            EventGenerationConfig config = new EventGenerationConfig();
            config.simulateInjuries = false;
            config.simulateWeather = false;
            config.simulateStreaks = false;
            return config;
        }

        public static EventGenerationConfig highInjury() {
            EventGenerationConfig config = new EventGenerationConfig();
            config.injuryMultiplier = 2.0;
            return config;
        }

        public boolean isSimulateInjuries() { return simulateInjuries; }
        public void setSimulateInjuries(boolean simulateInjuries) { this.simulateInjuries = simulateInjuries; }
        public boolean isSimulateWeather() { return simulateWeather; }
        public void setSimulateWeather(boolean simulateWeather) { this.simulateWeather = simulateWeather; }
        public boolean isSimulateStreaks() { return simulateStreaks; }
        public void setSimulateStreaks(boolean simulateStreaks) { this.simulateStreaks = simulateStreaks; }
        public double getInjuryMultiplier() { return injuryMultiplier; }
        public void setInjuryMultiplier(double injuryMultiplier) { this.injuryMultiplier = injuryMultiplier; }
        public double getWeatherMultiplier() { return weatherMultiplier; }
        public void setWeatherMultiplier(double weatherMultiplier) { this.weatherMultiplier = weatherMultiplier; }
        public double getStreakMultiplier() { return streakMultiplier; }
        public void setStreakMultiplier(double streakMultiplier) { this.streakMultiplier = streakMultiplier; }
    }
}
