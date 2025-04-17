package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Models.Seat;
import com.project.bookingmovieticketapp.Services.Room.RoomService;
import com.project.bookingmovieticketapp.Services.Seat.SeatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/rooms")
@RequiredArgsConstructor
public class RoomController {
    private final RoomService roomService;
    private final SeatService seatService;

    @GetMapping("/{id}")
    public ResponseEntity<?> getRoomById(@PathVariable int id)
    {
        try {
            return ResponseEntity.ok(roomService.getRoomById(id));
        }catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/{roomId}/seats")
    public ResponseEntity<?> getSeatsByRoomId(@PathVariable int roomId) {
        try {
            return ResponseEntity.ok(seatService.getSeatByRoomId(roomId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
