package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.BillingPlan;
import com.ffl.playoffs.domain.aggregate.Subscription;
import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.model.Price;
import com.ffl.playoffs.domain.model.SubscriptionStatus;
import com.ffl.playoffs.domain.port.BillingPlanRepository;
import com.ffl.playoffs.domain.port.SubscriptionRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CreateSubscriptionUseCase Tests")
class CreateSubscriptionUseCaseTest {

    @Mock
    private SubscriptionRepository subscriptionRepository;

    @Mock
    private BillingPlanRepository billingPlanRepository;

    private CreateSubscriptionUseCase useCase;

    private UUID adminId;
    private UUID billingPlanId;
    private BillingPlan paidPlan;
    private BillingPlan freePlan;

    @BeforeEach
    void setUp() {
        useCase = new CreateSubscriptionUseCase(subscriptionRepository, billingPlanRepository);
        adminId = UUID.randomUUID();
        billingPlanId = UUID.randomUUID();

        paidPlan = new BillingPlan("Premium", Price.usd(29.99), BillingCycle.MONTHLY);
        paidPlan.setId(billingPlanId);

        freePlan = new BillingPlan("Free", Price.free(), BillingCycle.ONE_TIME);
        freePlan.setId(UUID.randomUUID());
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should create paid subscription successfully")
        void shouldCreatePaidSubscriptionSuccessfully() {
            // Given
            CreateSubscriptionUseCase.CreateSubscriptionCommand command =
                new CreateSubscriptionUseCase.CreateSubscriptionCommand(adminId, billingPlanId);

            when(subscriptionRepository.hasActiveSubscription(adminId)).thenReturn(false);
            when(billingPlanRepository.findById(billingPlanId)).thenReturn(Optional.of(paidPlan));
            when(subscriptionRepository.save(any(Subscription.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

            // When
            Subscription result = useCase.execute(command);

            // Then
            assertThat(result.getAdminId()).isEqualTo(adminId);
            assertThat(result.getBillingPlanId()).isEqualTo(billingPlanId);
            assertThat(result.getBillingPlanName()).isEqualTo("Premium");
            assertThat(result.getStatus()).isEqualTo(SubscriptionStatus.PENDING);

            verify(subscriptionRepository).save(any(Subscription.class));
        }

        @Test
        @DisplayName("should auto-activate free subscription")
        void shouldAutoActivateFreeSubscription() {
            // Given
            CreateSubscriptionUseCase.CreateSubscriptionCommand command =
                new CreateSubscriptionUseCase.CreateSubscriptionCommand(adminId, freePlan.getId());

            when(subscriptionRepository.hasActiveSubscription(adminId)).thenReturn(false);
            when(billingPlanRepository.findById(freePlan.getId())).thenReturn(Optional.of(freePlan));
            when(subscriptionRepository.save(any(Subscription.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

            // When
            Subscription result = useCase.execute(command);

            // Then
            assertThat(result.getStatus()).isEqualTo(SubscriptionStatus.ACTIVE);
        }

        @Test
        @DisplayName("should throw exception when admin already has active subscription")
        void shouldThrowExceptionWhenAdminAlreadyHasActiveSubscription() {
            // Given
            CreateSubscriptionUseCase.CreateSubscriptionCommand command =
                new CreateSubscriptionUseCase.CreateSubscriptionCommand(adminId, billingPlanId);

            when(subscriptionRepository.hasActiveSubscription(adminId)).thenReturn(true);

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Admin already has an active subscription");

            verify(subscriptionRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when billing plan not found")
        void shouldThrowExceptionWhenBillingPlanNotFound() {
            // Given
            UUID nonExistentPlanId = UUID.randomUUID();
            CreateSubscriptionUseCase.CreateSubscriptionCommand command =
                new CreateSubscriptionUseCase.CreateSubscriptionCommand(adminId, nonExistentPlanId);

            when(subscriptionRepository.hasActiveSubscription(adminId)).thenReturn(false);
            when(billingPlanRepository.findById(nonExistentPlanId)).thenReturn(Optional.empty());

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Billing plan not found");

            verify(subscriptionRepository, never()).save(any());
        }

        @Test
        @DisplayName("should set external payment ID when provided")
        void shouldSetExternalPaymentIdWhenProvided() {
            // Given
            CreateSubscriptionUseCase.CreateSubscriptionCommand command =
                new CreateSubscriptionUseCase.CreateSubscriptionCommand(adminId, billingPlanId);
            command.setExternalPaymentId("stripe_sub_123");

            when(subscriptionRepository.hasActiveSubscription(adminId)).thenReturn(false);
            when(billingPlanRepository.findById(billingPlanId)).thenReturn(Optional.of(paidPlan));
            when(subscriptionRepository.save(any(Subscription.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

            // When
            Subscription result = useCase.execute(command);

            // Then
            assertThat(result.getExternalPaymentId()).isEqualTo("stripe_sub_123");
        }
    }
}
