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
 * MongoDB document for Score Update history
 * Tracks individual score changes for audit and reconciliation
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "score_updates")
@CompoundIndex(name = "player_time_idx", def = "{'league_player_id': 1, 'timestamp': -1}")
@CompoundIndex(name = "league_time_idx", def = "{'league_id': 1, 'timestamp': -1}")
public class ScoreUpdateDocument {

    @Id
    private String id;

    @Field("league_id")
    @Indexed
    private String leagueId;

    @Field("league_player_id")
    @Indexed
    private String leaguePlayerId;

    @Field("previous_score")
    private BigDecimal previousScore;

    @Field("new_score")
    private BigDecimal newScore;

    @Field("score_delta")
    private BigDecimal scoreDelta;

    @Field("updated_position")
    private String updatedPosition;

    @Field("nfl_player_id")
    private Long nflPlayerId;

    @Field("nfl_player_name")
    private String nflPlayerName;

    @Field("stat_update")
    private String statUpdate;

    @Field("status")
    private String status;

    @Field("idempotency_key")
    @Indexed(unique = true)
    private String idempotencyKey;

    @Field("timestamp")
    @Indexed
    private LocalDateTime timestamp;
}
