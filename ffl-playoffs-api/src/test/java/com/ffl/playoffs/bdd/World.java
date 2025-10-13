package com.ffl.playoffs.bdd;

import com.ffl.playoffs.domain.model.*;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * World class for sharing state across Cucumber step definitions
 * Uses scenario scope to maintain state within a scenario and prevent leakage
 */
@Component
@Scope("cucumber-glue")
public class World {

    // User context
    private User currentUser;
    private UUID currentUserId;
    private Role currentUserRole;
    private final Map<String, User> users = new HashMap<>();

    // League context
    private League currentLeague;
    private UUID currentLeagueId;
    private final Map<String, League> leagues = new HashMap<>();

    // PAT context
    private PersonalAccessToken currentPAT;
    private String currentPATToken;
    private final Map<String, PersonalAccessToken> pats = new HashMap<>();

    // Response context
    private Exception lastException;
    private Object lastResponse;
    private int lastStatusCode;

    // Test data
    private LocalDateTime testTime = LocalDateTime.now();

    /**
     * Reset all state - called before each scenario
     */
    public void reset() {
        currentUser = null;
        currentUserId = null;
        currentUserRole = null;
        users.clear();

        currentLeague = null;
        currentLeagueId = null;
        leagues.clear();

        currentPAT = null;
        currentPATToken = null;
        pats.clear();

        lastException = null;
        lastResponse = null;
        lastStatusCode = 0;

        testTime = LocalDateTime.now();
    }

    // User getters/setters
    public User getCurrentUser() {
        return currentUser;
    }

    public void setCurrentUser(User user) {
        this.currentUser = user;
        if (user != null) {
            this.currentUserId = user.getId();
            this.currentUserRole = user.getRole();
        }
    }

    public UUID getCurrentUserId() {
        return currentUserId;
    }

    public Role getCurrentUserRole() {
        return currentUserRole;
    }

    public void storeUser(String key, User user) {
        users.put(key, user);
    }

    public User getUser(String key) {
        return users.get(key);
    }

    // League getters/setters
    public League getCurrentLeague() {
        return currentLeague;
    }

    public void setCurrentLeague(League league) {
        this.currentLeague = league;
        if (league != null) {
            this.currentLeagueId = league.getId();
        }
    }

    public UUID getCurrentLeagueId() {
        return currentLeagueId;
    }

    public void storeLeague(String key, League league) {
        leagues.put(key, league);
    }

    public League getLeague(String key) {
        return leagues.get(key);
    }

    // PAT getters/setters
    public PersonalAccessToken getCurrentPAT() {
        return currentPAT;
    }

    public void setCurrentPAT(PersonalAccessToken pat) {
        this.currentPAT = pat;
    }

    public String getCurrentPATToken() {
        return currentPATToken;
    }

    public void setCurrentPATToken(String token) {
        this.currentPATToken = token;
    }

    public void storePAT(String key, PersonalAccessToken pat) {
        pats.put(key, pat);
    }

    public PersonalAccessToken getPAT(String key) {
        return pats.get(key);
    }

    // Response getters/setters
    public Exception getLastException() {
        return lastException;
    }

    public void setLastException(Exception exception) {
        this.lastException = exception;
    }

    public Object getLastResponse() {
        return lastResponse;
    }

    public void setLastResponse(Object response) {
        this.lastResponse = response;
    }

    public int getLastStatusCode() {
        return lastStatusCode;
    }

    public void setLastStatusCode(int statusCode) {
        this.lastStatusCode = statusCode;
    }

    // Time
    public LocalDateTime getTestTime() {
        return testTime;
    }

    public void setTestTime(LocalDateTime time) {
        this.testTime = time;
    }
}
