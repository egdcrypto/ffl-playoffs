Feature: Admin Marketplace Management
  As an Admin or Super Admin
  I want to manage the marketplace including vendors, products, pricing, and transactions
  So that players can purchase virtual items to enhance their fantasy football experience

  Background:
    Given the marketplace system is enabled
    And the payment processing service is configured
    And all transactions are stored in the Transaction table
    And all products are stored in the Product table

  # ===================
  # Marketplace Listing
  # ===================

  Scenario: Admin views the marketplace dashboard
    Given I am authenticated as an admin
    When I access the marketplace dashboard
    Then I see the following statistics:
      | totalProducts     | 45          |
      | activeProducts    | 38          |
      | totalVendors      | 5           |
      | activeVendors     | 4           |
      | totalTransactions | 1250        |
      | totalRevenue      | $12,500.00  |
    And I see a list of featured products
    And I see recent transactions summary

  Scenario: Admin views marketplace listings with filters
    Given I am authenticated as an admin
    And the marketplace has 50 products
    When I filter listings by:
      | category | TEAM_SKINS |
      | status   | ACTIVE     |
      | vendor   | vendor-123 |
    Then I see only products matching all filters
    And the results are paginated with 20 items per page
    And I can sort by price, name, or popularity

  Scenario: Admin views detailed marketplace analytics
    Given I am authenticated as an admin
    When I request marketplace analytics for the last 30 days
    Then I see:
      | dailyTransactions  | time series chart  |
      | revenueByCategory  | breakdown by type  |
      | topSellingProducts | ranked list        |
      | vendorPerformance  | revenue by vendor  |
      | conversionRate     | views to purchases |

  Scenario: Admin enables marketplace for a league
    Given I am authenticated as an admin
    And I own league "Playoffs 2024"
    And the marketplace is disabled for the league
    When I enable marketplace access for "Playoffs 2024"
    Then the marketplace is enabled for the league
    And players in the league can browse products
    And players in the league can make purchases

  Scenario: Admin disables marketplace for a league
    Given I am authenticated as an admin
    And I own league "Playoffs 2024"
    And the marketplace is enabled for the league
    When I disable marketplace access for "Playoffs 2024"
    Then the marketplace is disabled for the league
    And players can no longer make new purchases
    And existing purchases remain valid

  Scenario: Admin configures marketplace spending limits for a league
    Given I am authenticated as an admin
    And I own league "Playoffs 2024"
    When I configure spending limits:
      | maxDailySpend   | 50.00  |
      | maxWeeklySpend  | 200.00 |
      | maxMonthlySpend | 500.00 |
    Then the spending limits are applied to all players in the league
    And players cannot exceed these limits

  # ===================
  # Vendor Management
  # ===================

  Scenario: Super admin creates a new vendor
    Given I am authenticated as a super admin
    When I create a vendor with the following details:
      | name           | Premium Designs Inc         |
      | email          | vendor@premiumdesigns.com   |
      | description    | High-quality team graphics  |
      | commissionRate | 15                          |
      | paymentTerms   | NET_30                      |
    Then a new vendor is created
    And the vendor status is "PENDING_APPROVAL"
    And the vendor receives an onboarding email
    And a vendor portal account is created

  Scenario: Super admin approves a pending vendor
    Given I am authenticated as a super admin
    And a vendor "Premium Designs Inc" has status "PENDING_APPROVAL"
    And the vendor has completed onboarding requirements:
      | taxDocuments    | submitted |
      | bankDetails     | verified  |
      | termsAccepted   | true      |
    When I approve the vendor
    Then the vendor status changes to "ACTIVE"
    And the vendor can now list products
    And the vendor receives approval notification

  Scenario: Super admin rejects a vendor application
    Given I am authenticated as a super admin
    And a vendor "Sketchy Vendor" has status "PENDING_APPROVAL"
    When I reject the vendor with reason "Insufficient documentation"
    Then the vendor status changes to "REJECTED"
    And the vendor receives rejection notification with reason
    And the vendor can reapply after addressing concerns

  Scenario: Super admin suspends an active vendor
    Given I am authenticated as a super admin
    And vendor "Bad Actor Designs" is active with 10 listed products
    When I suspend the vendor with reason "Policy violation"
    Then the vendor status changes to "SUSPENDED"
    And all vendor products are hidden from the marketplace
    And pending vendor payouts are held
    And the vendor receives suspension notification

  Scenario: Super admin reactivates a suspended vendor
    Given I am authenticated as a super admin
    And vendor "Reformed Designs" has status "SUSPENDED"
    When I reactivate the vendor
    Then the vendor status changes to "ACTIVE"
    And previously hidden products become visible
    And held payouts are released for processing

  Scenario: Super admin updates vendor commission rate
    Given I am authenticated as a super admin
    And vendor "Premium Designs Inc" has commission rate 15%
    When I update the commission rate to 12%
    Then the new commission rate is applied
    And future transactions use the new rate
    And existing completed transactions are not affected

  Scenario: Admin views vendor performance metrics
    Given I am authenticated as an admin
    And vendor "Top Seller LLC" has been active for 6 months
    When I request performance metrics for the vendor
    Then I see:
      | totalSales         | 500        |
      | totalRevenue       | $5,000.00  |
      | averageRating      | 4.7        |
      | refundRate         | 2.5%       |
      | activeProducts     | 25         |
      | topSellingProduct  | Team Skin A|

  Scenario: Admin views vendor payout history
    Given I am authenticated as a super admin
    And vendor "Premium Designs Inc" has completed payouts
    When I view the vendor payout history
    Then I see all payouts with:
      | payoutDate    |
      | amount        |
      | transactionCount |
      | status        |
      | paymentMethod |

  Scenario: Vendor cannot be created with duplicate email
    Given I am authenticated as a super admin
    And a vendor exists with email "existing@vendor.com"
    When I attempt to create a vendor with email "existing@vendor.com"
    Then the request is rejected with error "VENDOR_EMAIL_EXISTS"
    And the error message is "A vendor with this email already exists"

  Scenario: Only super admins can manage vendors
    Given I am authenticated as a regular admin
    When I attempt to create a new vendor
    Then the request is rejected with 403 Forbidden
    And the error message is "Only SUPER_ADMIN can manage vendors"

  # ===================
  # Product Catalog
  # ===================

  Scenario: Admin creates a new product
    Given I am authenticated as an admin
    And vendor "Premium Designs Inc" is active
    When I create a product with the following details:
      | name           | Golden Eagle Team Skin          |
      | description    | Premium gold-themed team design |
      | category       | TEAM_SKINS                      |
      | vendorId       | vendor-123                      |
      | basePrice      | 9.99                            |
      | currency       | USD                             |
      | digitalAssetUrl| https://cdn.example.com/skins/golden-eagle.png |
    Then a new product is created
    And the product status is "DRAFT"
    And the product is not visible to players
    And the product has a unique SKU generated

  Scenario: Admin publishes a draft product
    Given I am authenticated as an admin
    And product "Golden Eagle Team Skin" has status "DRAFT"
    And the product has:
      | validPrice     | true  |
      | validAsset     | true  |
      | validMetadata  | true  |
    When I publish the product
    Then the product status changes to "ACTIVE"
    And the product is visible in the marketplace
    And the product publishedAt timestamp is set

  Scenario: Admin creates a product with multiple variants
    Given I am authenticated as an admin
    When I create a product with variants:
      | variant        | price  |
      | Standard       | 4.99   |
      | Premium        | 9.99   |
      | Ultimate       | 19.99  |
    Then a product is created with 3 variants
    And each variant has its own SKU
    And players can purchase individual variants

  Scenario: Admin updates product metadata
    Given I am authenticated as an admin
    And product "Golden Eagle Team Skin" exists
    When I update the product:
      | description | Updated premium gold design with new effects |
      | tags        | premium, gold, exclusive                     |
    Then the product metadata is updated
    And the product updatedAt timestamp is set
    And the product remains in its current status

  Scenario: Admin cannot update price of product with pending transactions
    Given I am authenticated as an admin
    And product "Golden Eagle Team Skin" has pending transactions
    When I attempt to update the product price
    Then the request is rejected with error "PENDING_TRANSACTIONS_EXIST"
    And the error message is "Cannot modify price while transactions are pending"

  Scenario: Admin archives a product
    Given I am authenticated as an admin
    And product "Discontinued Skin" is active
    When I archive the product
    Then the product status changes to "ARCHIVED"
    And the product is hidden from the marketplace
    And existing purchases of the product remain valid
    And the product cannot be purchased anymore

  Scenario: Admin restores an archived product
    Given I am authenticated as an admin
    And product "Retro Skin" has status "ARCHIVED"
    When I restore the product
    Then the product status changes to "ACTIVE"
    And the product is visible in the marketplace again

  Scenario: Admin sets product availability dates
    Given I am authenticated as an admin
    And product "Holiday Special Skin" exists
    When I set availability:
      | availableFrom | 2024-12-01T00:00:00Z |
      | availableTo   | 2024-12-31T23:59:59Z |
    Then the product is only purchasable within those dates
    And the product shows countdown before availability
    And the product shows "expired" after availability ends

  Scenario: Admin sets product purchase limits
    Given I am authenticated as an admin
    And product "Limited Edition Skin" exists
    When I set purchase limits:
      | maxPurchasesTotal    | 1000 |
      | maxPurchasesPerUser  | 1    |
    Then the product has inventory tracking enabled
    And players can only buy once per account
    And product becomes unavailable after 1000 total purchases

  Scenario: Admin views product inventory status
    Given I am authenticated as an admin
    And product "Limited Edition Skin" has 1000 max purchases
    And 750 units have been purchased
    When I view the product inventory
    Then I see:
      | totalInventory    | 1000 |
      | sold              | 750  |
      | remaining         | 250  |
      | percentSold       | 75%  |

  Scenario: Admin bulk updates product status
    Given I am authenticated as an admin
    And I select 5 draft products
    When I bulk publish the selected products
    Then all 5 products change status to "ACTIVE"
    And all 5 products become visible in the marketplace

  Scenario: Product categories are validated
    Given I am authenticated as an admin
    When I attempt to create a product with category "INVALID_CATEGORY"
    Then the request is rejected with error "INVALID_CATEGORY"
    And the valid categories are:
      | TEAM_SKINS      |
      | AVATARS         |
      | BADGES          |
      | CELEBRATIONS    |
      | POWER_UPS       |
      | SEASON_PASSES   |

  # ===================
  # Pricing Management
  # ===================

  Scenario: Admin sets product base price
    Given I am authenticated as an admin
    And product "Premium Skin" exists
    When I set the base price to 14.99 USD
    Then the product price is updated
    And the price history is recorded
    And the new price is effective immediately

  Scenario: Admin creates a time-limited discount
    Given I am authenticated as an admin
    And product "Premium Skin" has base price 14.99 USD
    When I create a discount:
      | discountType   | PERCENTAGE           |
      | discountValue  | 25                   |
      | startDate      | 2024-11-25T00:00:00Z |
      | endDate        | 2024-11-30T23:59:59Z |
      | description    | Black Friday Sale    |
    Then a discount is applied to the product
    And the effective price during the period is 11.24 USD
    And the original price is shown struck through

  Scenario: Admin creates a fixed amount discount
    Given I am authenticated as an admin
    And product "Season Pass" has base price 29.99 USD
    When I create a discount:
      | discountType   | FIXED_AMOUNT         |
      | discountValue  | 10.00                |
      | startDate      | 2024-12-01T00:00:00Z |
      | endDate        | 2024-12-15T23:59:59Z |
    Then the effective price during the period is 19.99 USD

  Scenario: Admin creates a promo code
    Given I am authenticated as an admin
    When I create a promo code:
      | code              | WINTER2024          |
      | discountType      | PERCENTAGE          |
      | discountValue     | 20                  |
      | maxUses           | 500                 |
      | maxUsesPerUser    | 1                   |
      | validFrom         | 2024-12-01T00:00:00Z|
      | validTo           | 2024-12-31T23:59:59Z|
      | applicableProducts| ALL                 |
    Then the promo code is created
    And players can apply the code at checkout
    And the code tracks usage count

  Scenario: Admin creates a category-specific promo code
    Given I am authenticated as an admin
    When I create a promo code:
      | code              | SKIN50              |
      | discountType      | PERCENTAGE          |
      | discountValue     | 50                  |
      | applicableCategories| TEAM_SKINS        |
    Then the promo code only applies to TEAM_SKINS products
    And attempting to use it on other categories fails

  Scenario: Admin views promo code usage
    Given I am authenticated as an admin
    And promo code "WINTER2024" has been used 150 times
    When I view promo code analytics
    Then I see:
      | totalUses         | 150        |
      | uniqueUsers       | 145        |
      | totalDiscountGiven| $450.00    |
      | remainingUses     | 350        |

  Scenario: Admin deactivates a promo code
    Given I am authenticated as an admin
    And promo code "EXPIRED_CODE" is active
    When I deactivate the promo code
    Then the promo code status changes to "INACTIVE"
    And the code can no longer be used at checkout
    And existing purchases with the code are not affected

  Scenario: Admin creates bundle pricing
    Given I am authenticated as an admin
    And products "Skin A", "Skin B", "Skin C" exist with prices 9.99 each
    When I create a bundle:
      | name          | Ultimate Skin Pack      |
      | products      | Skin A, Skin B, Skin C  |
      | bundlePrice   | 19.99                   |
      | savingsDisplay| Save $9.98              |
    Then a bundle product is created
    And the bundle shows savings compared to individual purchase
    And purchasing the bundle grants all included products

  Scenario: Admin sets regional pricing
    Given I am authenticated as an admin
    And product "Premium Skin" has base price 14.99 USD
    When I set regional prices:
      | region | currency | price |
      | EU     | EUR      | 12.99 |
      | UK     | GBP      | 10.99 |
      | JP     | JPY      | 1500  |
    Then players see prices in their local currency
    And exchange rate differences are handled

  Scenario: Discount cannot exceed product price
    Given I am authenticated as an admin
    And product "Budget Skin" has base price 4.99 USD
    When I attempt to create a discount of 6.00 USD
    Then the request is rejected with error "DISCOUNT_EXCEEDS_PRICE"
    And the error message is "Discount cannot exceed product price"

  Scenario: Admin views pricing history
    Given I am authenticated as an admin
    And product "Premium Skin" has had 5 price changes
    When I view the pricing history
    Then I see all price changes with:
      | previousPrice |
      | newPrice      |
      | changedAt     |
      | changedBy     |
      | reason        |

  # ===================
  # Transaction Handling
  # ===================

  Scenario: Admin views all transactions
    Given I am authenticated as an admin
    When I request all marketplace transactions
    Then I see a paginated list of transactions with:
      | transactionId   |
      | playerId        |
      | productName     |
      | amount          |
      | status          |
      | createdAt       |
      | paymentMethod   |

  Scenario: Admin filters transactions by status
    Given I am authenticated as an admin
    When I filter transactions by status "COMPLETED"
    Then I see only completed transactions
    And pending, failed, and refunded transactions are excluded

  Scenario: Admin filters transactions by date range
    Given I am authenticated as an admin
    When I filter transactions:
      | from | 2024-10-01T00:00:00Z |
      | to   | 2024-10-31T23:59:59Z |
    Then I see only transactions within that date range

  Scenario: Admin views transaction details
    Given I am authenticated as an admin
    And transaction "txn-123" exists
    When I view transaction details for "txn-123"
    Then I see:
      | transactionId    | txn-123              |
      | status           | COMPLETED            |
      | playerId         | player-456           |
      | playerEmail      | player@example.com   |
      | productId        | prod-789             |
      | productName      | Golden Eagle Skin    |
      | amount           | 9.99                 |
      | currency         | USD                  |
      | paymentMethod    | CREDIT_CARD          |
      | paymentProcessor | STRIPE               |
      | processorTxnId   | ch_abc123            |
      | createdAt        | 2024-10-15T14:30:00Z |
      | completedAt      | 2024-10-15T14:30:05Z |
      | promoCodeUsed    | FALL2024             |
      | discountApplied  | 2.00                 |

  Scenario: Admin processes a refund
    Given I am authenticated as an admin
    And transaction "txn-123" has status "COMPLETED"
    And the transaction was completed within the refund window
    When I process a refund for "txn-123" with reason "Customer request"
    Then a refund is initiated
    And the transaction status changes to "REFUND_PENDING"
    And the player receives refund notification
    And the product access is revoked upon refund completion

  Scenario: Admin processes a partial refund
    Given I am authenticated as an admin
    And transaction "txn-123" was for 19.99 USD
    When I process a partial refund of 10.00 USD with reason "Partial credit"
    Then a partial refund is initiated
    And the refund amount is 10.00 USD
    And the player retains product access

  Scenario: Admin cannot refund transaction outside refund window
    Given I am authenticated as an admin
    And transaction "txn-old" was completed 45 days ago
    And the refund window is 30 days
    When I attempt to process a refund for "txn-old"
    Then the request is rejected with error "REFUND_WINDOW_EXPIRED"
    And the error message is "Refund window of 30 days has expired"

  Scenario: Admin views refund history
    Given I am authenticated as an admin
    And 50 refunds have been processed this month
    When I view refund history for the current month
    Then I see all refunds with:
      | refundId          |
      | originalTxnId     |
      | amount            |
      | reason            |
      | processedBy       |
      | processedAt       |
      | status            |

  Scenario: Admin handles failed transaction
    Given I am authenticated as an admin
    And transaction "txn-failed" has status "FAILED"
    And the failure reason is "Payment declined"
    When I view the failed transaction
    Then I see the failure details:
      | status        | FAILED           |
      | failureReason | Payment declined |
      | failureCode   | card_declined    |
    And I can see recommended actions

  Scenario: Admin manually completes a stuck transaction
    Given I am authenticated as an admin
    And transaction "txn-stuck" has status "PENDING"
    And the transaction has been pending for over 1 hour
    And payment confirmation was received from processor
    When I manually complete the transaction
    Then the transaction status changes to "COMPLETED"
    And the player receives their product
    And an audit log entry is created

  Scenario: Admin views transaction dispute
    Given I am authenticated as an admin
    And transaction "txn-disputed" has a chargeback filed
    When I view the dispute details
    Then I see:
      | disputeId       | disp-123           |
      | originalTxnId   | txn-disputed       |
      | disputeReason   | PRODUCT_NOT_RECEIVED |
      | disputeAmount   | 9.99               |
      | filedAt         | 2024-10-20T10:00:00Z |
      | status          | OPEN               |
      | evidenceDueBy   | 2024-10-27T10:00:00Z |

  Scenario: Admin submits dispute evidence
    Given I am authenticated as an admin
    And dispute "disp-123" requires evidence
    When I submit dispute evidence:
      | deliveryProof    | Product delivered to account on 2024-10-15 |
      | usageProof       | Player used product 5 times since purchase |
      | communicationLog | No complaints received from player         |
    Then the evidence is submitted to the payment processor
    And the dispute status changes to "EVIDENCE_SUBMITTED"

  Scenario: Admin exports transaction report
    Given I am authenticated as an admin
    When I export transactions for October 2024 as CSV
    Then a CSV file is generated with all transaction data
    And the file includes:
      | transactionId   |
      | date            |
      | playerEmail     |
      | product         |
      | amount          |
      | status          |
      | paymentMethod   |

  Scenario: Transaction creates audit trail
    Given a player purchases product "Premium Skin"
    Then an audit log entry is created:
      | action        | PURCHASE              |
      | playerId      | player-123            |
      | productId     | prod-456              |
      | amount        | 9.99                  |
      | status        | COMPLETED             |
      | timestamp     | <now>                 |

  Scenario: Admin views revenue breakdown by vendor
    Given I am authenticated as an admin
    When I request revenue breakdown for October 2024
    Then I see:
      | vendorName           | grossRevenue | commission | netToVendor |
      | Premium Designs Inc  | $5,000.00    | $750.00    | $4,250.00   |
      | Elite Graphics       | $3,000.00    | $450.00    | $2,550.00   |
      | Budget Skins Co      | $2,000.00    | $300.00    | $1,700.00   |

  Scenario: System generates vendor payout report
    Given I am authenticated as a super admin
    And it is the end of the payment period
    When I generate vendor payout report
    Then a report is generated showing:
      | vendorName           | transactionCount | grossAmount | commission | netPayout |
      | Premium Designs Inc  | 250              | $2,500.00   | $375.00    | $2,125.00 |
    And each vendor receives their payout summary

  # ===================
  # Error Cases
  # ===================

  Scenario: Player cannot access admin marketplace functions
    Given I am authenticated as a player
    When I attempt to access the marketplace admin dashboard
    Then the request is rejected with 403 Forbidden

  Scenario: Admin cannot manage products for suspended vendor
    Given I am authenticated as an admin
    And vendor "Suspended Vendor" has status "SUSPENDED"
    When I attempt to create a product for the vendor
    Then the request is rejected with error "VENDOR_SUSPENDED"
    And the error message is "Cannot create products for suspended vendor"

  Scenario: Transaction amount must be positive
    Given I am authenticated as an admin
    When I attempt to process a transaction with amount 0
    Then the request is rejected with error "INVALID_AMOUNT"
    And the error message is "Transaction amount must be greater than zero"

  Scenario: Promo code cannot have negative discount
    Given I am authenticated as an admin
    When I attempt to create a promo code with discountValue -10
    Then the request is rejected with error "INVALID_DISCOUNT_VALUE"
    And the error message is "Discount value must be positive"

  Scenario: Product SKU must be unique
    Given I am authenticated as an admin
    And a product exists with SKU "SKU-12345"
    When I attempt to create a product with SKU "SKU-12345"
    Then the request is rejected with error "DUPLICATE_SKU"
    And the error message is "A product with this SKU already exists"

  Scenario: Concurrent purchase exhausts limited inventory
    Given product "Limited Skin" has 1 remaining inventory
    When two players attempt to purchase simultaneously
    Then one purchase succeeds with status "COMPLETED"
    And one purchase fails with error "OUT_OF_STOCK"
    And the failed player is not charged
