package com.ffl.playoffs.application.dto;

import java.util.List;

/**
 * Generic paginated response wrapper
 * Contains the page data and metadata about pagination
 *
 * @param <T> The type of content in this page
 */
public class Page<T> {
    private List<T> content;
    private int page;
    private int size;
    private long totalElements;
    private int totalPages;
    private boolean hasNext;
    private boolean hasPrevious;
    private String sort;
    private PageLinks links;

    public Page() {
    }

    public Page(List<T> content, int page, int size, long totalElements) {
        this(content, page, size, totalElements, null);
    }

    public Page(List<T> content, int page, int size, long totalElements, String sort) {
        this.content = content;
        this.page = page;
        this.size = size;
        this.totalElements = totalElements;
        this.totalPages = (int) Math.ceil((double) totalElements / size);
        this.hasNext = page < totalPages - 1;
        this.hasPrevious = page > 0;
        this.sort = sort;
    }

    public static <T> Page<T> of(List<T> content, PageRequest pageRequest, long totalElements) {
        return new Page<>(content, pageRequest.getPage(), pageRequest.getSize(),
                         totalElements, pageRequest.getSort());
    }

    public List<T> getContent() {
        return content;
    }

    public void setContent(List<T> content) {
        this.content = content;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public long getTotalElements() {
        return totalElements;
    }

    public void setTotalElements(long totalElements) {
        this.totalElements = totalElements;
        this.totalPages = (int) Math.ceil((double) totalElements / size);
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public boolean isHasNext() {
        return hasNext;
    }

    public void setHasNext(boolean hasNext) {
        this.hasNext = hasNext;
    }

    public boolean isHasPrevious() {
        return hasPrevious;
    }

    public void setHasPrevious(boolean hasPrevious) {
        this.hasPrevious = hasPrevious;
    }

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public PageLinks getLinks() {
        return links;
    }

    public void setLinks(PageLinks links) {
        this.links = links;
    }
}
