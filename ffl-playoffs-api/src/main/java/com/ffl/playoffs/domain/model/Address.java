package com.ffl.playoffs.domain.model;

import java.util.Objects;

/**
 * Value object representing a physical address.
 */
public class Address {

    private final String street;
    private final String city;
    private final String state;
    private final String postalCode;
    private final String country;

    private Address(String street, String city, String state, String postalCode, String country) {
        this.street = street;
        this.city = city;
        this.state = state;
        this.postalCode = postalCode;
        this.country = country;
    }

    public static Address of(String street, String city, String state,
                             String postalCode, String country) {
        return new Address(street, city, state, postalCode, country);
    }

    public static Address usAddress(String street, String city, String state, String postalCode) {
        return new Address(street, city, state, postalCode, "USA");
    }

    public static Builder builder() {
        return new Builder();
    }

    /**
     * Returns short form: "City, State"
     */
    public String getShortForm() {
        return city + ", " + state;
    }

    /**
     * Returns full address as a single line.
     */
    public String getFullAddress() {
        return String.format("%s, %s, %s %s, %s",
                street, city, state, postalCode, country);
    }

    public String getStreet() {
        return street;
    }

    public String getCity() {
        return city;
    }

    public String getState() {
        return state;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public String getCountry() {
        return country;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Address address = (Address) o;
        return Objects.equals(street, address.street) &&
               Objects.equals(city, address.city) &&
               Objects.equals(state, address.state) &&
               Objects.equals(postalCode, address.postalCode) &&
               Objects.equals(country, address.country);
    }

    @Override
    public int hashCode() {
        return Objects.hash(street, city, state, postalCode, country);
    }

    @Override
    public String toString() {
        return getFullAddress();
    }

    public static class Builder {
        private String street;
        private String city;
        private String state;
        private String postalCode;
        private String country = "USA";

        public Builder street(String street) {
            this.street = street;
            return this;
        }

        public Builder city(String city) {
            this.city = city;
            return this;
        }

        public Builder state(String state) {
            this.state = state;
            return this;
        }

        public Builder postalCode(String postalCode) {
            this.postalCode = postalCode;
            return this;
        }

        public Builder country(String country) {
            this.country = country;
            return this;
        }

        public Address build() {
            return new Address(street, city, state, postalCode, country);
        }
    }
}
