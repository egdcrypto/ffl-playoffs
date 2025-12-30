@ANIMA-1137
Feature: Vector Search

As a user of the narrative engine
I want to search for content using semantic search
So that I can find relevant information across worlds and documents
Background:
Given I am authenticated as a valid user
And I have the following worlds with content:
| world          | documents                          | characters        |
| Fantasy World  | Dragon Lore, Magic Systems         | Merlin, Gandalf   |
| Sci-Fi World   | Space Travel, Alien Cultures       | Spock, Data       |
| Mystery World  | Detective Methods, Crime Scenes    | Sherlock, Poirot  |
- Scenario: Search for characters by description
- Scenario: Search for documents by content
- Scenario: Cross-world semantic search
- Scenario: Search with filters
- Scenario: Fuzzy search tolerance
- Scenario: Search result snippets
- Scenario: Recent content prioritization
- Scenario: Search suggestions
- Scenario: Save search queries
- Scenario: Search analytics
- Scenario: Multi-language search
- Scenario: Search API pagination