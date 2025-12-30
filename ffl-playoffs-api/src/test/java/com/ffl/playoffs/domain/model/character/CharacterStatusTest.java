package com.ffl.playoffs.domain.model.character;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("CharacterStatus Enum Tests")
class CharacterStatusTest {

    @Test
    @DisplayName("should have exactly three statuses")
    void shouldHaveExactlyThreeStatuses() {
        assertThat(CharacterStatus.values()).hasSize(3);
    }

    @Test
    @DisplayName("should have correct codes")
    void shouldHaveCorrectCodes() {
        assertThat(CharacterStatus.DRAFT.getCode()).isEqualTo("draft");
        assertThat(CharacterStatus.ACTIVE.getCode()).isEqualTo("active");
        assertThat(CharacterStatus.ELIMINATED.getCode()).isEqualTo("eliminated");
    }

    @Nested
    @DisplayName("fromCode tests")
    class FromCodeTests {

        @Test
        @DisplayName("should resolve from code")
        void shouldResolveFromCode() {
            assertThat(CharacterStatus.fromCode("draft")).isEqualTo(CharacterStatus.DRAFT);
            assertThat(CharacterStatus.fromCode("active")).isEqualTo(CharacterStatus.ACTIVE);
            assertThat(CharacterStatus.fromCode("eliminated")).isEqualTo(CharacterStatus.ELIMINATED);
        }

        @Test
        @DisplayName("should resolve from code case insensitively")
        void shouldResolveFromCodeCaseInsensitively() {
            assertThat(CharacterStatus.fromCode("DRAFT")).isEqualTo(CharacterStatus.DRAFT);
            assertThat(CharacterStatus.fromCode("Active")).isEqualTo(CharacterStatus.ACTIVE);
            assertThat(CharacterStatus.fromCode("ELIMINATED")).isEqualTo(CharacterStatus.ELIMINATED);
        }

        @Test
        @DisplayName("should throw exception for unknown code")
        void shouldThrowExceptionForUnknownCode() {
            assertThatThrownBy(() -> CharacterStatus.fromCode("unknown"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Unknown character status code");
        }
    }

    @Nested
    @DisplayName("status check tests")
    class StatusCheckTests {

        @Test
        @DisplayName("isDraft should return true only for DRAFT")
        void isDraftShouldReturnTrueOnlyForDraft() {
            assertThat(CharacterStatus.DRAFT.isDraft()).isTrue();
            assertThat(CharacterStatus.ACTIVE.isDraft()).isFalse();
            assertThat(CharacterStatus.ELIMINATED.isDraft()).isFalse();
        }

        @Test
        @DisplayName("isActive should return true only for ACTIVE")
        void isActiveShouldReturnTrueOnlyForActive() {
            assertThat(CharacterStatus.DRAFT.isActive()).isFalse();
            assertThat(CharacterStatus.ACTIVE.isActive()).isTrue();
            assertThat(CharacterStatus.ELIMINATED.isActive()).isFalse();
        }

        @Test
        @DisplayName("isEliminated should return true only for ELIMINATED")
        void isEliminatedShouldReturnTrueOnlyForEliminated() {
            assertThat(CharacterStatus.DRAFT.isEliminated()).isFalse();
            assertThat(CharacterStatus.ACTIVE.isEliminated()).isFalse();
            assertThat(CharacterStatus.ELIMINATED.isEliminated()).isTrue();
        }
    }

    @Nested
    @DisplayName("transition tests")
    class TransitionTests {

        @Test
        @DisplayName("canActivate should return true only for DRAFT")
        void canActivateShouldReturnTrueOnlyForDraft() {
            assertThat(CharacterStatus.DRAFT.canActivate()).isTrue();
            assertThat(CharacterStatus.ACTIVE.canActivate()).isFalse();
            assertThat(CharacterStatus.ELIMINATED.canActivate()).isFalse();
        }

        @Test
        @DisplayName("canEliminate should return true only for ACTIVE")
        void canEliminateShouldReturnTrueOnlyForActive() {
            assertThat(CharacterStatus.DRAFT.canEliminate()).isFalse();
            assertThat(CharacterStatus.ACTIVE.canEliminate()).isTrue();
            assertThat(CharacterStatus.ELIMINATED.canEliminate()).isFalse();
        }

        @Test
        @DisplayName("getNextStatus should return correct next status")
        void getNextStatusShouldReturnCorrectNextStatus() {
            assertThat(CharacterStatus.DRAFT.getNextStatus()).isEqualTo(CharacterStatus.ACTIVE);
            assertThat(CharacterStatus.ACTIVE.getNextStatus()).isEqualTo(CharacterStatus.ELIMINATED);
            assertThat(CharacterStatus.ELIMINATED.getNextStatus()).isNull();
        }

        @Test
        @DisplayName("getPreviousStatus should return correct previous status")
        void getPreviousStatusShouldReturnCorrectPreviousStatus() {
            assertThat(CharacterStatus.DRAFT.getPreviousStatus()).isNull();
            assertThat(CharacterStatus.ACTIVE.getPreviousStatus()).isEqualTo(CharacterStatus.DRAFT);
            assertThat(CharacterStatus.ELIMINATED.getPreviousStatus()).isEqualTo(CharacterStatus.ACTIVE);
        }
    }

    @Nested
    @DisplayName("capability tests")
    class CapabilityTests {

        @Test
        @DisplayName("canMakeSelections should return true only for ACTIVE")
        void canMakeSelectionsShouldReturnTrueOnlyForActive() {
            assertThat(CharacterStatus.DRAFT.canMakeSelections()).isFalse();
            assertThat(CharacterStatus.ACTIVE.canMakeSelections()).isTrue();
            assertThat(CharacterStatus.ELIMINATED.canMakeSelections()).isFalse();
        }

        @Test
        @DisplayName("canAccumulateScore should return true only for ACTIVE")
        void canAccumulateScoreShouldReturnTrueOnlyForActive() {
            assertThat(CharacterStatus.DRAFT.canAccumulateScore()).isFalse();
            assertThat(CharacterStatus.ACTIVE.canAccumulateScore()).isTrue();
            assertThat(CharacterStatus.ELIMINATED.canAccumulateScore()).isFalse();
        }
    }

    @Nested
    @DisplayName("terminal state tests")
    class TerminalStateTests {

        @Test
        @DisplayName("isTerminal should return true only for ELIMINATED")
        void isTerminalShouldReturnTrueOnlyForEliminated() {
            assertThat(CharacterStatus.DRAFT.isTerminal()).isFalse();
            assertThat(CharacterStatus.ACTIVE.isTerminal()).isFalse();
            assertThat(CharacterStatus.ELIMINATED.isTerminal()).isTrue();
        }

        @Test
        @DisplayName("isInCompetition should return true for DRAFT and ACTIVE")
        void isInCompetitionShouldReturnTrueForDraftAndActive() {
            assertThat(CharacterStatus.DRAFT.isInCompetition()).isTrue();
            assertThat(CharacterStatus.ACTIVE.isInCompetition()).isTrue();
            assertThat(CharacterStatus.ELIMINATED.isInCompetition()).isFalse();
        }
    }

    @Nested
    @DisplayName("display name tests")
    class DisplayNameTests {

        @Test
        @DisplayName("should have display names")
        void shouldHaveDisplayNames() {
            assertThat(CharacterStatus.DRAFT.getDisplayName()).isEqualTo("Draft");
            assertThat(CharacterStatus.ACTIVE.getDisplayName()).isEqualTo("Active");
            assertThat(CharacterStatus.ELIMINATED.getDisplayName()).isEqualTo("Eliminated");
        }

        @Test
        @DisplayName("should have descriptions")
        void shouldHaveDescriptions() {
            assertThat(CharacterStatus.DRAFT.getDescription()).contains("preparation");
            assertThat(CharacterStatus.ACTIVE.getDescription()).contains("participating");
            assertThat(CharacterStatus.ELIMINATED.getDescription()).contains("eliminated");
        }
    }
}
