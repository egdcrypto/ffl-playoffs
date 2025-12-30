@notebook @jupyter @external-processing @entity-extraction @MVP-FOUNDATION
Feature: Notebook Integration for External Processing
  As a developer or power user
  I want to use Jupyter notebooks for custom entity extraction
  So that I can experiment with different models and approaches

  Background:
    Given I am authenticated as a user with developer permissions
    And I have access to external GPU resources
    And the notebook integration service is enabled
    And I want to customize entity extraction

  # ==========================================
  # Provide Customizable Notebook Templates
  # ==========================================

  @templates @catalog
  Scenario: Browse available notebook templates
    Given the template catalog is populated
    When I access the notebook template catalog
    Then I should see templates organized by category:
      | category            | template_count |
      | entity_extraction   | 8              |
      | text_classification | 5              |
      | named_entity_recognition | 6         |
      | relationship_extraction | 4          |
      | custom_models       | 3              |
    And each template should display description and requirements

  @templates @create-from-template
  Scenario: Create notebook from template
    Given template "NER with spaCy" exists
    When I create a new notebook from this template
    Then a new notebook should be created with:
      | component           | included |
      | import_statements   | yes      |
      | data_loading_cells  | yes      |
      | model_setup_cells   | yes      |
      | training_cells      | yes      |
      | evaluation_cells    | yes      |
      | export_cells        | yes      |
    And the notebook should be ready for customization

  @templates @entity-extraction
  Scenario: Use entity extraction template
    Given I select the "Custom Entity Extractor" template
    When the notebook is generated
    Then it should include cells for:
      | cell_purpose              | description                        |
      | environment_setup         | Install dependencies, GPU check    |
      | data_connection           | Connect to platform data sources   |
      | entity_schema_definition  | Define custom entity types         |
      | model_selection           | Choose base model architecture     |
      | training_pipeline         | Fine-tuning workflow               |
      | validation                | Test extraction accuracy           |
      | deployment_export         | Package model for platform         |

  @templates @gpu-optimized
  Scenario: Template optimized for GPU resources
    Given I have access to GPU resources
    When I select a GPU-optimized template
    Then the notebook should include:
      | optimization           | description                    |
      | cuda_detection         | Verify GPU availability        |
      | batch_size_tuning      | Optimize for GPU memory        |
      | mixed_precision        | Enable FP16 training           |
      | gradient_checkpointing | Reduce memory footprint        |
    And GPU utilization guidance should be provided

  @templates @colab-compatible
  Scenario: Template compatible with Google Colab
    Given I want to use Google Colab free tier
    When I select a Colab-compatible template
    Then the notebook should include:
      | compatibility_feature     | description                    |
      | colab_setup_cells         | Drive mounting, dependencies   |
      | session_persistence       | Checkpoint saving              |
      | memory_management         | Clear unused variables         |
      | timeout_handling          | Save before session ends       |

  @templates @versioning
  Scenario: Template version management
    Given template "Transformer NER" has multiple versions
    When I view template versions
    Then I should see version history:
      | version | date       | changes                    |
      | 3.0     | 2024-01-15 | Added transformer support  |
      | 2.1     | 2023-11-20 | Bug fixes                  |
      | 2.0     | 2023-09-01 | Performance improvements   |
    And I should be able to select any version

  # ==========================================
  # Enable Notebook Customization
  # ==========================================

  @customization @parameters
  Scenario: Customize notebook parameters
    Given I have a notebook from template
    When I configure custom parameters:
      | parameter          | value                    |
      | model_name         | bert-base-uncased        |
      | batch_size         | 32                       |
      | learning_rate      | 2e-5                     |
      | epochs             | 10                       |
      | entity_types       | character,location,item  |
    Then parameters should be injected into notebook cells
    And cells should be updated with custom values

  @customization @cells
  Scenario: Add custom cells to notebook
    Given I have an existing notebook
    When I add custom cells:
      | cell_type | purpose                        |
      | code      | Custom preprocessing function  |
      | markdown  | Documentation for my approach  |
      | code      | Additional validation logic    |
    Then cells should be added at specified positions
    And notebook should remain executable

  @customization @data-source
  Scenario: Configure custom data sources
    Given I want to use my own training data
    When I configure data source:
      | source_type | connection_details           |
      | platform    | world_id: my-world-123       |
      | local_file  | /content/training_data.json  |
      | remote_url  | https://data.example.com/set |
    Then data loading cells should be updated
    And connection should be tested

  @customization @model-architecture
  Scenario: Customize model architecture
    Given I am modifying the model configuration
    When I specify architecture changes:
      | component       | customization              |
      | base_model      | roberta-large              |
      | hidden_layers   | add 2 custom layers        |
      | attention_heads | 16                         |
      | dropout         | 0.2                        |
    Then model definition cells should be updated
    And architecture diagram should be generated

  @customization @preprocessing
  Scenario: Add custom preprocessing pipeline
    Given I need special text preprocessing
    When I define preprocessing steps:
      | step              | configuration              |
      | tokenization      | custom_tokenizer_v2        |
      | normalization     | lowercase, remove_accents  |
      | augmentation      | synonym_replacement        |
      | filtering         | min_length: 10             |
    Then preprocessing cells should be added
    And pipeline should be testable on sample data

  @customization @save
  Scenario: Save notebook customizations
    Given I have made customizations to a notebook
    When I save the notebook
    Then customizations should be persisted
    And notebook should be versioned
    And I should be able to revert to previous versions

  # ==========================================
  # Maintain Model Registry for Notebooks
  # ==========================================

  @registry @browse
  Scenario: Browse model registry
    Given the model registry contains trained models
    When I browse the registry
    Then I should see models with:
      | field           | description                    |
      | model_name      | Unique identifier              |
      | model_type      | NER, classification, etc.      |
      | base_model      | Parent model used              |
      | performance     | Accuracy, F1 scores            |
      | created_date    | When model was trained         |
      | creator         | Who created the model          |

  @registry @register
  Scenario: Register trained model from notebook
    Given I have trained a model in my notebook
    When I register the model:
      | field           | value                          |
      | name            | custom-ner-fantasy-v1          |
      | description     | NER for fantasy entities       |
      | entity_types    | character,location,magic_item  |
      | base_model      | bert-base-uncased              |
      | metrics         | f1: 0.92, precision: 0.94      |
    Then model should be added to registry
    And model artifacts should be stored
    And model should be available for deployment

  @registry @versioning
  Scenario: Version models in registry
    Given model "custom-ner-fantasy" exists with version 1.0
    When I register an updated version:
      | version | changes                      | metrics      |
      | 2.0     | Improved character detection | f1: 0.95     |
    Then new version should be added
    And previous version should remain available
    And version comparison should be possible

  @registry @metadata
  Scenario: Store comprehensive model metadata
    Given I am registering a model
    When I provide metadata:
      | metadata_field       | value                         |
      | training_data_size   | 50000 samples                 |
      | training_duration    | 4 hours                       |
      | gpu_used             | NVIDIA T4                     |
      | hyperparameters      | lr=2e-5, batch=32, epochs=10  |
      | validation_split     | 0.2                           |
      | random_seed          | 42                            |
    Then all metadata should be stored
    And metadata should be queryable

  @registry @search
  Scenario: Search model registry
    Given multiple models are registered
    When I search with criteria:
      | criteria        | value              |
      | entity_type     | character          |
      | min_f1_score    | 0.85               |
      | base_model      | bert               |
    Then matching models should be returned
    And results should be sorted by performance

  @registry @download
  Scenario: Download model for notebook use
    Given model "production-ner-v3" exists in registry
    When I download the model to my notebook
    Then model files should be available locally
    And model should be loadable in notebook
    And model configuration should be accessible

  @registry @deprecation
  Scenario: Deprecate outdated models
    Given model "old-ner-v1" is outdated
    When I deprecate the model
    Then model should be marked as deprecated
    And warning should appear when accessed
    And replacement model should be suggested

  # ==========================================
  # Support Collaborative Notebook Development
  # ==========================================

  @collaboration @sharing
  Scenario: Share notebook with team members
    Given I have a working notebook
    When I share with team members:
      | user          | permission |
      | alice@team    | edit       |
      | bob@team      | view       |
      | charlie@team  | execute    |
    Then users should receive access
    And permissions should be enforced
    And sharing should be logged

  @collaboration @real-time
  Scenario: Real-time collaborative editing
    Given notebook is shared with collaborators
    When multiple users edit simultaneously
    Then changes should sync in real-time
    And cursor positions should be visible
    And conflicts should be resolved automatically

  @collaboration @comments
  Scenario: Add comments to notebook cells
    Given I am reviewing a shared notebook
    When I add comments:
      | cell_index | comment                              |
      | 3          | Consider using larger batch size     |
      | 7          | This preprocessing step seems slow   |
      | 12         | Great improvement on accuracy!       |
    Then comments should be visible to collaborators
    And comment notifications should be sent
    And comments should be resolvable

  @collaboration @branching
  Scenario: Create notebook branch for experimentation
    Given I want to try a different approach
    When I create a branch "experiment-transformer"
    Then a copy of the notebook should be created
    And I can make changes without affecting main
    And branches should be listable

  @collaboration @merge
  Scenario: Merge notebook branches
    Given I have completed experiment in branch
    When I request merge to main notebook
    Then changes should be compared
    And conflicts should be highlighted
    And merge should be reviewable before applying

  @collaboration @history
  Scenario: View notebook edit history
    Given notebook has been edited multiple times
    When I view edit history
    Then I should see all changes:
      | timestamp        | user    | action           |
      | 2024-01-15 10:00 | alice   | Modified cell 5  |
      | 2024-01-15 11:30 | bob     | Added cell 8     |
      | 2024-01-16 09:00 | alice   | Deleted cell 3   |
    And I should be able to restore any version

  @collaboration @review
  Scenario: Request notebook review
    Given I have completed notebook development
    When I request review from expert
    Then review request should be sent
    And reviewer should receive notification
    And reviewer can approve or request changes

  # ==========================================
  # Optimize for Free Tier Limits
  # ==========================================

  @free-tier @colab
  Scenario: Optimize for Google Colab free tier
    Given I am using Google Colab free tier
    When I configure notebook for free tier
    Then notebook should include:
      | optimization          | description                    |
      | session_management    | Handle 12-hour limit           |
      | memory_optimization   | Stay under RAM limit           |
      | gpu_scheduling        | Efficient GPU usage            |
      | checkpoint_frequency  | Regular saving                 |

  @free-tier @session-persistence
  Scenario: Persist work across Colab sessions
    Given Colab session may disconnect
    When I enable session persistence
    Then checkpoints should save to Google Drive
    And progress should be resumable
    And data should be cached efficiently

  @free-tier @memory-management
  Scenario: Manage memory within free tier limits
    Given free tier has 12GB RAM limit
    When processing large datasets
    Then data should be processed in chunks
    And variables should be cleared when unused
    And garbage collection should be triggered
    And memory usage should be monitored

  @free-tier @gpu-optimization
  Scenario: Optimize GPU usage for free tier
    Given Colab free tier GPU is limited
    When running training
    Then batch sizes should be optimized
    And gradient accumulation should be used
    And model should be loaded efficiently
    And GPU memory should be monitored

  @free-tier @kaggle
  Scenario: Optimize for Kaggle free tier
    Given I am using Kaggle notebooks
    When I configure for Kaggle
    Then notebook should handle:
      | constraint          | optimization              |
      | 30 hour weekly GPU  | Efficient scheduling      |
      | session limits      | Checkpoint saves          |
      | output size limits  | Compressed model storage  |

  @free-tier @timeout-handling
  Scenario: Handle session timeout gracefully
    Given session may timeout unexpectedly
    When timeout is detected
    Then current state should be saved
    And user should be notified
    And recovery instructions should be provided
    And work should be resumable

  @free-tier @resource-estimation
  Scenario: Estimate resource requirements
    Given I want to run a training job
    When I request resource estimation
    Then system should calculate:
      | resource        | estimate                  |
      | gpu_hours       | 2.5 hours                 |
      | memory_peak     | 8GB                       |
      | storage_needed  | 500MB                     |
      | free_tier_fit   | yes/no                    |
    And recommendations should be provided

  # ==========================================
  # Create Notebook Marketplace
  # ==========================================

  @marketplace @browse
  Scenario: Browse notebook marketplace
    Given the marketplace has community notebooks
    When I browse the marketplace
    Then I should see notebooks with:
      | field           | description              |
      | title           | Notebook name            |
      | author          | Creator                  |
      | rating          | Community rating         |
      | downloads       | Usage count              |
      | category        | Entity type/use case     |
      | preview         | Screenshot/description   |

  @marketplace @publish
  Scenario: Publish notebook to marketplace
    Given I have a working notebook
    When I publish to marketplace:
      | field           | value                          |
      | title           | Fantasy NER with BERT          |
      | description     | Extracts fantasy entities      |
      | category        | named_entity_recognition       |
      | tags            | fantasy, NER, BERT             |
      | license         | MIT                            |
      | price           | free                           |
    Then notebook should be listed
    And it should be discoverable by search
    And I should be listed as author

  @marketplace @rating
  Scenario: Rate and review marketplace notebooks
    Given I have used a marketplace notebook
    When I submit a review:
      | field   | value                              |
      | rating  | 4 stars                            |
      | review  | Great starting point, easy to use  |
    Then review should be published
    And notebook rating should update
    And author should be notified

  @marketplace @premium
  Scenario: List premium notebook in marketplace
    Given I have a high-quality notebook
    When I list as premium:
      | field         | value              |
      | price         | $9.99              |
      | preview       | first 3 cells      |
      | license       | commercial         |
      | support       | email support      |
    Then premium listing should be created
    And purchase flow should be enabled
    And revenue sharing should apply

  @marketplace @verification
  Scenario: Verify marketplace notebook quality
    Given a notebook is submitted to marketplace
    When verification process runs
    Then notebook should be checked for:
      | check               | result       |
      | executes_cleanly    | pass/fail    |
      | no_malicious_code   | pass/fail    |
      | proper_documentation| pass/fail    |
      | license_valid       | pass/fail    |
    And verification badge should be awarded if passed

  @marketplace @fork
  Scenario: Fork marketplace notebook
    Given I want to customize a marketplace notebook
    When I fork the notebook
    Then a copy should be created in my workspace
    And original author should be credited
    And fork relationship should be tracked

  @marketplace @updates
  Scenario: Receive updates for installed notebooks
    Given I have installed a marketplace notebook
    And author publishes an update
    When I check for updates
    Then I should see available update
    And I should see changelog
    And I can apply update preserving my customizations

  # ==========================================
  # Provide Debugging Tools in Notebooks
  # ==========================================

  @debugging @visualization
  Scenario: Visualize entity extraction results
    Given I have run entity extraction in notebook
    When I use the visualization tools
    Then I should see:
      | visualization       | description                    |
      | entity_highlighting | Entities marked in text        |
      | confidence_heatmap  | Confidence scores visualized   |
      | entity_distribution | Charts of entity types         |
      | error_analysis      | Misclassified examples         |

  @debugging @step-through
  Scenario: Step through extraction pipeline
    Given I want to debug the extraction process
    When I enable step-through mode
    Then I can pause at each pipeline stage:
      | stage           | inspectable_data           |
      | tokenization    | tokens, positions          |
      | embedding       | vector representations     |
      | prediction      | raw model outputs          |
      | post-processing | final entities             |
    And I can modify data at each stage

  @debugging @comparison
  Scenario: Compare extraction results
    Given I have ground truth labels
    When I run comparison analysis
    Then I should see:
      | metric              | value    |
      | precision           | 0.92     |
      | recall              | 0.88     |
      | f1_score            | 0.90     |
      | confusion_matrix    | visual   |
    And mismatches should be highlighted

  @debugging @profiling
  Scenario: Profile notebook performance
    Given I want to optimize notebook speed
    When I run performance profiling
    Then I should see:
      | metric              | breakdown              |
      | cell_execution_time | per cell timing        |
      | memory_usage        | peak and average       |
      | gpu_utilization     | usage percentage       |
      | bottlenecks         | slow operations        |
    And optimization suggestions should be provided

  @debugging @logging
  Scenario: Configure detailed logging
    Given I need to debug issues
    When I enable detailed logging:
      | log_level | components                    |
      | DEBUG     | model, preprocessing          |
      | INFO      | training, validation          |
      | WARNING   | all                           |
    Then logs should capture specified detail
    And logs should be searchable
    And logs should be exportable

  @debugging @assertions
  Scenario: Add debugging assertions
    Given I want to verify intermediate results
    When I add assertions:
      | assertion                          | description            |
      | assert len(entities) > 0           | Entities extracted     |
      | assert confidence > 0.5            | Minimum confidence     |
      | assert all(e.type in valid_types)  | Valid entity types     |
    Then assertions should run with code
    And failures should be clearly reported

  @debugging @interactive
  Scenario: Interactive entity inspector
    Given extraction has completed
    When I use interactive inspector
    Then I can click on any entity to see:
      | information         | details                  |
      | span                | start and end positions  |
      | confidence          | model confidence score   |
      | alternatives        | other possible types     |
      | context             | surrounding text         |
    And I can manually correct entities

  # ==========================================
  # Learn from Notebook Experiments
  # ==========================================

  @learning @experiment-tracking
  Scenario: Track notebook experiments
    Given I am running multiple experiments
    When I enable experiment tracking
    Then each run should be logged with:
      | tracked_item        | description              |
      | hyperparameters     | All config values        |
      | metrics             | Performance results      |
      | artifacts           | Model files, outputs     |
      | environment         | Dependencies, versions   |
      | git_commit          | Code version             |

  @learning @comparison
  Scenario: Compare experiment results
    Given I have multiple experiment runs
    When I compare experiments
    Then I should see side-by-side comparison:
      | experiment  | f1_score | training_time | model_size |
      | run_001     | 0.88     | 2h 15m        | 420MB      |
      | run_002     | 0.91     | 3h 30m        | 650MB      |
      | run_003     | 0.90     | 2h 45m        | 430MB      |
    And I can identify best configuration

  @learning @hyperparameter-analysis
  Scenario: Analyze hyperparameter impact
    Given I have run experiments with varying hyperparameters
    When I request hyperparameter analysis
    Then I should see:
      | analysis            | visualization           |
      | parameter_importance| Bar chart               |
      | correlation_matrix  | Heatmap                 |
      | optimal_ranges      | Range plots             |
    And recommendations should be provided

  @learning @insights
  Scenario: Generate insights from experiments
    Given multiple experiments have been tracked
    When I request experiment insights
    Then system should analyze patterns:
      | insight_type        | example                        |
      | best_practices      | Larger batch improves speed    |
      | common_failures     | OOM with model X on free tier  |
      | optimization_tips   | Use mixed precision training   |

  @learning @share-findings
  Scenario: Share experiment findings
    Given I have valuable experiment results
    When I share findings with team
    Then findings should include:
      | component           | details                    |
      | summary             | Key takeaways              |
      | methodology         | How experiments were run   |
      | results             | Performance comparisons    |
      | recommendations     | Best approach identified   |

  @learning @feedback-loop
  Scenario: Feed notebook results back to platform
    Given my notebook achieved high accuracy
    When I export results to platform
    Then extraction improvements should be captured
    And model can be proposed for platform use
    And contribution should be credited

  # ==========================================
  # Handle Notebook Processing Failures
  # ==========================================

  @failures @detection
  Scenario: Detect notebook execution failure
    Given a notebook cell raises an exception
    When failure is detected
    Then execution should stop at failed cell
    And error message should be displayed
    And stack trace should be available
    And recovery options should be suggested

  @failures @timeout
  Scenario: Handle cell execution timeout
    Given a cell is taking too long
    When execution timeout is reached
    Then cell should be interrupted
    And partial results should be saved
    And user should be notified
    And timeout threshold should be configurable

  @failures @memory
  Scenario: Handle out-of-memory errors
    Given notebook exceeds available memory
    When OOM error occurs
    Then error should be caught gracefully
    And memory usage should be reported
    And suggestions should include:
      | suggestion              | description              |
      | reduce_batch_size       | Use smaller batches      |
      | use_gradient_checkpoint | Save memory during train |
      | chunk_data              | Process in smaller parts |
      | upgrade_resources       | Use larger instance      |

  @failures @gpu
  Scenario: Handle GPU unavailability
    Given notebook requires GPU
    And GPU is not available
    When execution is attempted
    Then clear error should be shown
    And CPU fallback should be offered
    And GPU availability should be checked
    And queue for GPU should be available

  @failures @dependency
  Scenario: Handle missing dependencies
    Given notebook requires specific packages
    When dependency is missing
    Then missing package should be identified
    And installation command should be suggested
    And auto-install option should be available
    And compatibility should be checked

  @failures @data
  Scenario: Handle data loading failures
    Given notebook expects specific data format
    When data loading fails
    Then error should clearly identify issue:
      | issue_type          | message                        |
      | file_not_found      | Data file not found at path    |
      | format_mismatch     | Expected JSON, got CSV         |
      | permission_denied   | Cannot access data source      |
      | corrupt_data        | Invalid data structure         |
    And remediation steps should be provided

  @failures @checkpoint
  Scenario: Recover from failure using checkpoint
    Given notebook was running with checkpoints
    And failure occurred after checkpoint
    When I request recovery
    Then state should be restored from checkpoint
    And I can resume from last saved point
    And lost progress should be minimized

  @failures @retry
  Scenario: Configure automatic retry for transient failures
    Given some failures may be transient
    When I configure retry policy:
      | setting          | value              |
      | max_retries      | 3                  |
      | retry_delay      | 30 seconds         |
      | exponential_backoff | true            |
      | retry_on         | timeout, network   |
    Then transient failures should retry automatically
    And permanent failures should fail fast

  @failures @notification
  Scenario: Notify user of long-running notebook failure
    Given notebook is running in background
    And failure occurs
    When notification is triggered
    Then user should receive alert via:
      | channel         | content                    |
      | email           | Failure summary and logs   |
      | platform_ui     | Dashboard notification     |
      | webhook         | JSON payload if configured |

  # ==========================================
  # Notebook Execution Environment
  # ==========================================

  @environment @setup
  Scenario: Configure notebook execution environment
    Given I am setting up a new notebook
    When I configure environment:
      | setting           | value                    |
      | python_version    | 3.10                     |
      | gpu_type          | T4                       |
      | memory            | 16GB                     |
      | storage           | 50GB                     |
    Then environment should be provisioned
    And dependencies should be installed
    And environment should be reproducible

  @environment @dependencies
  Scenario: Manage notebook dependencies
    Given notebook requires specific packages
    When I define dependencies:
      | package         | version    |
      | transformers    | 4.35.0     |
      | torch           | 2.1.0      |
      | spacy           | 3.7.0      |
      | pandas          | 2.1.0      |
    Then requirements file should be generated
    And packages should be installed
    And versions should be pinned

  @environment @isolation
  Scenario: Ensure environment isolation
    Given multiple notebooks may run concurrently
    When notebooks execute
    Then each notebook should have isolated environment
    And one notebook cannot affect another
    And resources should be properly allocated

  @environment @cleanup
  Scenario: Clean up notebook resources
    Given notebook execution has completed
    When cleanup is triggered
    Then GPU memory should be released
    And temporary files should be deleted
    And environment should be tear down
    And resource usage should be logged

  # ==========================================
  # Integration with Platform
  # ==========================================

  @integration @data-access
  Scenario: Access platform data from notebook
    Given I need platform world data in notebook
    When I connect to platform:
      | connection        | details                  |
      | api_key           | my-api-key               |
      | world_id          | world-123                |
      | entity_types      | character, location      |
    Then data should be accessible in notebook
    And data should be in usable format
    And updates should sync bidirectionally

  @integration @export-model
  Scenario: Export trained model to platform
    Given I have trained a model in notebook
    When I export to platform:
      | export_setting    | value                    |
      | model_name        | custom-ner-v1            |
      | target_format     | onnx                     |
      | deploy_immediately| false                    |
    Then model should be packaged correctly
    And model should be uploaded to platform
    And model should be available for use

  @integration @results-sync
  Scenario: Sync extraction results to platform
    Given I have extracted entities in notebook
    When I sync results to platform
    Then entities should be created in platform
    And entity relationships should be preserved
    And extraction provenance should be recorded

  @integration @webhook
  Scenario: Configure webhook notifications
    Given I want to be notified of notebook events
    When I configure webhook:
      | event               | webhook_url                |
      | execution_complete  | https://my.webhook/done    |
      | failure             | https://my.webhook/failed  |
      | model_registered    | https://my.webhook/model   |
    Then webhooks should fire on events
    And payload should include relevant details

  # ==========================================
  # Error Handling and Edge Cases
  # ==========================================

  @error-handling @invalid-notebook
  Scenario: Handle invalid notebook format
    Given notebook file is corrupted or invalid
    When I attempt to open it
    Then appropriate error should be shown
    And recovery suggestions should be provided
    And backup should be attempted if available

  @error-handling @quota-exceeded
  Scenario: Handle resource quota exceeded
    Given user has limited compute quota
    And quota is exhausted
    When execution is attempted
    Then quota exceeded error should be shown
    And usage statistics should be displayed
    And upgrade options should be presented

  @edge-case @large-notebook
  Scenario: Handle very large notebooks
    Given notebook has 500+ cells
    When notebook is loaded
    Then performance should remain acceptable
    And cell virtualization should be used
    And navigation should work smoothly

  @edge-case @long-running
  Scenario: Handle long-running training jobs
    Given training will take 24+ hours
    When job is submitted
    Then progress should be trackable
    And job should survive session changes
    And notifications should be sent on completion
    And resources should be managed efficiently

  @edge-case @concurrent-edits
  Scenario: Handle concurrent edit conflicts
    Given multiple users edit same cell
    When conflict occurs
    Then both versions should be preserved
    And conflict resolution UI should appear
    And users should be able to merge changes
