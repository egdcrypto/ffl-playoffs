package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.BillingPlan;
import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.port.BillingPlanRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CreateBillingPlanUseCase Tests")
class CreateBillingPlanUseCaseTest {

    @Mock
    private BillingPlanRepository billingPlanRepository;

    private CreateBillingPlanUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new CreateBillingPlanUseCase(billingPlanRepository);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should create billing plan successfully")
        void shouldCreateBillingPlanSuccessfully() {
            // Given
            CreateBillingPlanUseCase.CreateBillingPlanCommand command =
                new CreateBillingPlanUseCase.CreateBillingPlanCommand(
                    "Premium Plan",
                    BigDecimal.valueOf(29.99),
                    "USD",
                    BillingCycle.MONTHLY
                );
            command.setDescription("Premium features for serious players");
            command.setMaxLeagues(10);
            command.setMaxPlayersPerLeague(50);
            command.setAdvancedScoringEnabled(true);
            command.setCustomBrandingEnabled(true);
            command.setPrioritySupportEnabled(true);
            command.setFeatured(true);

            when(billingPlanRepository.existsByName("Premium Plan")).thenReturn(false);
            when(billingPlanRepository.save(any(BillingPlan.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

            // When
            BillingPlan result = useCase.execute(command);

            // Then
            assertThat(result.getName()).isEqualTo("Premium Plan");
            assertThat(result.getDescription()).isEqualTo("Premium features for serious players");
            assertThat(result.getPrice().getAmount()).isEqualByComparingTo(BigDecimal.valueOf(29.99));
            assertThat(result.getBillingCycle()).isEqualTo(BillingCycle.MONTHLY);
            assertThat(result.getMaxLeagues()).isEqualTo(10);
            assertThat(result.getMaxPlayersPerLeague()).isEqualTo(50);
            assertThat(result.getAdvancedScoringEnabled()).isTrue();
            assertThat(result.getCustomBrandingEnabled()).isTrue();
            assertThat(result.getPrioritySupportEnabled()).isTrue();
            assertThat(result.isFeatured()).isTrue();

            verify(billingPlanRepository).existsByName("Premium Plan");
            verify(billingPlanRepository).save(any(BillingPlan.class));
        }

        @Test
        @DisplayName("should create billing plan with minimal fields")
        void shouldCreateBillingPlanWithMinimalFields() {
            // Given
            CreateBillingPlanUseCase.CreateBillingPlanCommand command =
                new CreateBillingPlanUseCase.CreateBillingPlanCommand(
                    "Basic Plan",
                    BigDecimal.valueOf(9.99),
                    "USD",
                    BillingCycle.MONTHLY
                );

            when(billingPlanRepository.existsByName("Basic Plan")).thenReturn(false);
            when(billingPlanRepository.save(any(BillingPlan.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

            // When
            BillingPlan result = useCase.execute(command);

            // Then
            assertThat(result.getName()).isEqualTo("Basic Plan");
            assertThat(result.getPrice().getAmount()).isEqualByComparingTo(BigDecimal.valueOf(9.99));
            assertThat(result.isFeatured()).isFalse();
        }

        @Test
        @DisplayName("should throw exception when plan name already exists")
        void shouldThrowExceptionWhenPlanNameAlreadyExists() {
            // Given
            CreateBillingPlanUseCase.CreateBillingPlanCommand command =
                new CreateBillingPlanUseCase.CreateBillingPlanCommand(
                    "Existing Plan",
                    BigDecimal.valueOf(19.99),
                    "USD",
                    BillingCycle.MONTHLY
                );

            when(billingPlanRepository.existsByName("Existing Plan")).thenReturn(true);

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Billing plan name already exists");

            verify(billingPlanRepository, never()).save(any());
        }
    }
}
