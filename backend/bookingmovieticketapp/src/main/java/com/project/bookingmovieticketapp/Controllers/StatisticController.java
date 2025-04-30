package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Services.Booking.BookingService;
import lombok.RequiredArgsConstructor;
import org.springframework.cglib.core.Local;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/statistics")
@RequiredArgsConstructor
public class StatisticController {
    private final BookingService bookingService;

    @GetMapping("")
    public ResponseEntity<?> getMonthlyStatistics(
    ) {
        try {
            LocalDateTime now = LocalDateTime.now();
            int month = now.getMonthValue();
            int year = now.getYear();

            Map<String, Object> statistics = new HashMap<>();
            statistics.put("mostBookedMovie", bookingService.getMostBookedMovie(month, year));
            statistics.put("secondMostBookedMovie", bookingService.getSecondMostBookedMovie(month, year));
            statistics.put("thirdMostBookedMovie", bookingService.getThirdMostBookedMovie(month, year));
            statistics.put("totalRevenue", bookingService.calculateMonthlyRevenue(month, year));
            statistics.put("mostBookedCinema", bookingService.getMostBookedCinema(month, year));

            return ResponseEntity.ok(statistics);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
