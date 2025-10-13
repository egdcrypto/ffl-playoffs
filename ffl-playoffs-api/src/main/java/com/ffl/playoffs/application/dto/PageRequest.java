package com.ffl.playoffs.application.dto;

/**
 * Page request parameters for pagination
 * Represents the client's request for a specific page of data
 */
public class PageRequest {
    private int page;
    private int size;
    private String sort;

    public static final int DEFAULT_PAGE = 0;
    public static final int DEFAULT_SIZE = 20;
    public static final int MAX_SIZE = 100;

    public PageRequest() {
        this(DEFAULT_PAGE, DEFAULT_SIZE);
    }

    public PageRequest(int page, int size) {
        this(page, size, null);
    }

    public PageRequest(int page, int size, String sort) {
        this.page = Math.max(0, page);
        this.size = Math.min(Math.max(1, size), MAX_SIZE);
        this.sort = sort;
    }

    public static PageRequest of(int page, int size) {
        return new PageRequest(page, size);
    }

    public static PageRequest of(int page, int size, String sort) {
        return new PageRequest(page, size, sort);
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = Math.max(0, page);
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        if (size > MAX_SIZE) {
            throw new IllegalArgumentException("Maximum page size is " + MAX_SIZE);
        }
        this.size = Math.max(1, size);
    }

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public int getOffset() {
        return page * size;
    }
}
