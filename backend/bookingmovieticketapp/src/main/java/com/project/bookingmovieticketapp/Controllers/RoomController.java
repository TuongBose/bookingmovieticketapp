package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.DTOs.RoomDTO;
import com.project.bookingmovieticketapp.Models.Room;
import com.project.bookingmovieticketapp.Models.Seat;
import com.project.bookingmovieticketapp.Responses.RoomResponse;
import com.project.bookingmovieticketapp.Services.Room.RoomService;
import com.project.bookingmovieticketapp.Services.Seat.SeatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/rooms")
@RequiredArgsConstructor
public class RoomController {
    private final RoomService roomService;
    private final SeatService seatService;

    @GetMapping("/{id}")
    public ResponseEntity<?> getRoomById(@PathVariable int id) {
        try {
            return ResponseEntity.ok(roomService.getRoomById(id));
        } catch (Exception e) {
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

    @GetMapping
    public ResponseEntity<?> getAllRooms() {
        try {
            List<RoomResponse> rooms = roomService.getAllRooms();
            return ResponseEntity.ok(rooms);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping
    public ResponseEntity<?> createRoom(@RequestBody RoomDTO roomDTO) {
        try {
            Room newRoom = roomService.createRoom(roomDTO);
            return ResponseEntity.ok(newRoom);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateRoom(@PathVariable int id, @RequestBody RoomDTO roomDTO) {
        try {
            Room updatedRoom = roomService.updateRoom(id, roomDTO);
            return ResponseEntity.ok(updatedRoom);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteRoom(@PathVariable int id) {
        try {
            roomService.deleteRoom(id);
            return ResponseEntity.ok("Xóa phòng thành công.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/cinema/{cinemaid}")
    public ResponseEntity<?> getRoomsByCinemaId(@PathVariable int cinemaid) {
        try {
            return ResponseEntity.ok(roomService.getRoomByCinemaId(cinemaid));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
