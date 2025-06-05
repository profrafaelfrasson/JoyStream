package com.joystream.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class DateUtil {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static String formatarDataBrasileira(String dataOriginal) {
        if (dataOriginal == null || dataOriginal.trim().isEmpty() || dataOriginal.equals("N/A")) {
            return "N/A";
        }
        try {
            LocalDate data = LocalDate.parse(dataOriginal);
            return data.format(DATE_FORMATTER);
        } catch (Exception e) {
            return "N/A";
        }
    }
} 