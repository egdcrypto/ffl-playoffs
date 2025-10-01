package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.UserDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert between User domain model and UserDocument
 * Infrastructure layer
 */
@Component
public class UserMapper {

    /**
     * Converts User domain entity to UserDocument
     * @param user the domain entity
     * @return the MongoDB document
     */
    public UserDocument toDocument(User user) {
        if (user == null) {
            return null;
        }

        UserDocument document = new UserDocument();
        document.setId(user.getId() != null ? user.getId().toString() : null);
        document.setEmail(user.getEmail());
        document.setName(user.getName());
        document.setGoogleId(user.getGoogleId());
        document.setRole(user.getRole() != null ? user.getRole().name() : null);
        document.setCreatedAt(user.getCreatedAt());
        document.setLastLoginAt(user.getLastLoginAt());
        document.setActive(user.isActive());

        return document;
    }

    /**
     * Converts UserDocument to User domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public User toDomain(UserDocument document) {
        if (document == null) {
            return null;
        }

        User user = new User();
        user.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        user.setEmail(document.getEmail());
        user.setName(document.getName());
        user.setGoogleId(document.getGoogleId());
        user.setRole(document.getRole() != null ? Role.valueOf(document.getRole()) : null);
        user.setCreatedAt(document.getCreatedAt());
        user.setLastLoginAt(document.getLastLoginAt());
        user.setActive(document.isActive());

        return user;
    }
}
