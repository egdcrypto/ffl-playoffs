package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.GameDTO;
import com.ffl.playoffs.application.service.ApplicationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/games")
@RequiredArgsConstructor
public class GameController {
    private final ApplicationService applicationService;
    
    @PostMapping
    public ResponseEntity<GameDTO> createGame(@RequestBody CreateGameRequest request) {
        GameDTO game = applicationService.createGame(
                request.getGameName(), 
                request.getCreatorEmail()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(game);
    }
    
    @PostMapping("/join")
    public ResponseEntity<String> joinGame(@RequestBody JoinGameRequest request) {
        applicationService.invitePlayer(
                request.getInviteCode(),
                request.getEmail(),
                request.getDisplayName(),
                request.getGoogleId()
        );
        return ResponseEntity.ok("Successfully joined game");
    }
}

class CreateGameRequest {
    private String gameName;
    private String creatorEmail;
    
    public String getGameName() { return gameName; }
    public void setGameName(String gameName) { this.gameName = gameName; }
    public String getCreatorEmail() { return creatorEmail; }
    public void setCreatorEmail(String creatorEmail) { this.creatorEmail = creatorEmail; }
}

class JoinGameRequest {
    private String inviteCode;
    private String email;
    private String displayName;
    private String googleId;
    
    public String getInviteCode() { return inviteCode; }
    public void setInviteCode(String inviteCode) { this.inviteCode = inviteCode; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }
    public String getGoogleId() { return googleId; }
    public void setGoogleId(String googleId) { this.googleId = googleId; }
}
