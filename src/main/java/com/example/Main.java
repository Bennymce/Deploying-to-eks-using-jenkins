package com.example;

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        // Keep the application running
        try {
            Thread.sleep(Long.MAX_VALUE); // Infinite sleep to keep the container alive
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}

