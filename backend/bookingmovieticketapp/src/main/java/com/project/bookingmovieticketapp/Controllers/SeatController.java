package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Services.Seat.SeatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/seats")
@RequiredArgsConstructor
public class SeatController {
    private final SeatService seatService;

    @GetMapping("")
    public ResponseEntity<?> getSeatByRoomId(@RequestParam int roomId) {
        try {
            return ResponseEntity.ok(seatService.getSeatByRoomId(roomId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
