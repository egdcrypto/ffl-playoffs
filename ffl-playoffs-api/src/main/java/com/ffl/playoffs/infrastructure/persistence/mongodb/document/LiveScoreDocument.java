package com.ffl.playoffs.infrastructure.persistence.mongodb.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * MongoDB document for Live Score data
 * Stores real-time score updates during live games
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "live_scores")
@CompoundIndex(name = "league_player_idx", def = "{'league_id': 1, 'league_player_id': 1}")
@CompoundIndex(name = "player_timestamp_idx", def = "{'league_player_id': 1, 'updated_at': -1}")
public class LiveScoreDocument {

    @Id
    private String id;

    @Field("league_id")
    @Indexed
    private String leagueId;

    @Field("league_player_id")
    @Indexed
    private String leaguePlayerId;

    @Field("player_name")
    private String playerName;

    @Field("current_score")
    private BigDecimal currentScore;

    @Field("previous_score")
    private BigDecimal previousScore;

    @Field("score_delta")
    private BigDecimal scoreDelta;

    @Field("status")
    private String status;  // LIVE, FINAL, SUSPENDED, PARTIAL, DELAYED

    @Field("current_rank")
    private Integer currentRank;

    @Field("previous_rank")
    private Integer previousRank;

    @Field("week")
    private Integer week;

    @Field("season")
    private Integer season;

    @Field("created_at")
    private LocalDateTime createdAt;

    @Field("updated_at")
    @Indexed
    private LocalDateTime updatedAt;
}
