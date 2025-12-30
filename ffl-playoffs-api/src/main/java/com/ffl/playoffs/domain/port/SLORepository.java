package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.SLO;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for SLO aggregate
 * Port in hexagonal architecture
 */
public interface SLORepository {

    /**
     * Find SLO by ID
     * @param id the SLO ID
     * @return Optional containing the SLO if found
     */
    Optional<SLO> findById(UUID id);

    /**
     * Find SLO by name
     * @param name the SLO name
     * @return Optional containing the SLO if found
     */
    Optional<SLO> findByName(String name);

    /**
     * Find all SLOs
     * @return list of all SLOs
     */
    List<SLO> findAll();

    /**
     * Find enabled SLOs
     * @return list of enabled SLOs
     */
    List<SLO> findEnabled();

    /**
     * Find SLOs by service name
     * @param serviceName the service name
     * @return list of SLOs for the service
     */
    List<SLO> findByServiceName(String serviceName);

    /**
     * Find SLOs with exceeded burn rate
     * @return list of SLOs burning budget faster than allowed
     */
    List<SLO> findWithExceededBurnRate();

    /**
     * Find SLOs not meeting their target
     * @return list of SLOs below target
     */
    List<SLO> findNotMeetingTarget();

    /**
     * Save an SLO
     * @param slo the SLO to save
     * @return the saved SLO
     */
    SLO save(SLO slo);

    /**
     * Delete an SLO
     * @param id the SLO ID
     */
    void deleteById(UUID id);
}
