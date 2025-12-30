package com.ffl.playoffs.infrastructure.adapter.persistence.stub;

import com.ffl.playoffs.application.dto.NFLTeamDTO;
import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;
import com.ffl.playoffs.domain.port.NFLTeamRepository;
import org.springframework.stereotype.Repository;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

/**
 * Stub implementation of NFLTeamRepository for testing and development
 */
@Repository
public class NFLTeamRepositoryStub implements NFLTeamRepository {

    @Override
    public Page<NFLTeamDTO> findAll(PageRequest pageRequest) {
        return new Page<>(Collections.emptyList(), pageRequest.getPage(), pageRequest.getSize(), 0);
    }

    @Override
    public Page<NFLTeamDTO> findByConference(String conference, PageRequest pageRequest) {
        return new Page<>(Collections.emptyList(), pageRequest.getPage(), pageRequest.getSize(), 0);
    }

    @Override
    public Page<NFLTeamDTO> findByDivision(String division, PageRequest pageRequest) {
        return new Page<>(Collections.emptyList(), pageRequest.getPage(), pageRequest.getSize(), 0);
    }

    @Override
    public Optional<NFLTeamDTO> findByName(String name) {
        return Optional.empty();
    }

    @Override
    public Optional<NFLTeamDTO> findByAbbreviation(String abbreviation) {
        return Optional.empty();
    }

    @Override
    public List<NFLTeamDTO> findAll() {
        return Collections.emptyList();
    }
}
