package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Incident;
import com.ffl.playoffs.domain.model.IncidentSeverity;
import com.ffl.playoffs.domain.model.IncidentStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for Incident aggregate
 * Port in hexagonal architecture
 */
public interface IncidentRepository {

    /**
     * Find incident by ID
     * @param id the incident ID
     * @return Optional containing the incident if found
     */
    Optional<Incident> findById(UUID id);

    /**
     * Find incident by incident number
     * @param incidentNumber the incident number (e.g., INC-12345)
     * @return Optional containing the incident if found
     */
    Optional<Incident> findByIncidentNumber(String incidentNumber);

    /**
     * Find all incidents
     * @return list of all incidents
     */
    List<Incident> findAll();

    /**
     * Find active incidents (not resolved or closed)
     * @return list of active incidents
     */
    List<Incident> findActive();

    /**
     * Find incidents by status
     * @param status the incident status
     * @return list of incidents with the specified status
     */
    List<Incident> findByStatus(IncidentStatus status);

    /**
     * Find incidents by severity
     * @param severity the severity level
     * @return list of incidents with the specified severity
     */
    List<Incident> findBySeverity(IncidentSeverity severity);

    /**
     * Find incidents created after a specific date
     * @param after the date to search from
     * @return list of incidents created after the date
     */
    List<Incident> findCreatedAfter(LocalDateTime after);

    /**
     * Find incidents assigned to a specific admin
     * @param adminId the admin ID
     * @return list of assigned incidents
     */
    List<Incident> findByAssignedTo(UUID adminId);

    /**
     * Save an incident
     * @param incident the incident to save
     * @return the saved incident
     */
    Incident save(Incident incident);

    /**
     * Delete an incident
     * @param id the incident ID
     */
    void deleteById(UUID id);
}
