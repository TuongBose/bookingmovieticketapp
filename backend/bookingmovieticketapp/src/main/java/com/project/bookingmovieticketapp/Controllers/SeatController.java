package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Services.Seat.SeatService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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

    @GetMapping("/{id}")
    public ResponseEntity<?> getSeatById(@Valid @PathVariable int id) {
        try {
            return ResponseEntity.ok(seatService.getSeatById(id));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
