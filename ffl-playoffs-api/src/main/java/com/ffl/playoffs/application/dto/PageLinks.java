package com.ffl.playoffs.application.dto;

/**
 * Navigation links for pagination
 * Follows HATEOAS principles
 */
public class PageLinks {
    private String first;
    private String previous;
    private String self;
    private String next;
    private String last;

    public PageLinks() {
    }

    public PageLinks(String first, String previous, String self, String next, String last) {
        this.first = first;
        this.previous = previous;
        this.self = self;
        this.next = next;
        this.last = last;
    }

    public String getFirst() {
        return first;
    }

    public void setFirst(String first) {
        this.first = first;
    }

    public String getPrevious() {
        return previous;
    }

    public void setPrevious(String previous) {
        this.previous = previous;
    }

    public String getSelf() {
        return self;
    }

    public void setSelf(String self) {
        this.self = self;
    }

    public String getNext() {
        return next;
    }

    public void setNext(String next) {
        this.next = next;
    }

    public String getLast() {
        return last;
    }

    public void setLast(String last) {
        this.last = last;
    }
}
