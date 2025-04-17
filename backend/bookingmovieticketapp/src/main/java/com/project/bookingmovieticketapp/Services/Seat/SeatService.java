package com.project.bookingmovieticketapp.Services.Seat;

import com.project.bookingmovieticketapp.DTOs.SeatDTO;
import com.project.bookingmovieticketapp.Models.Room;
import com.project.bookingmovieticketapp.Models.Seat;
import com.project.bookingmovieticketapp.Repositories.RoomRepository;
import com.project.bookingmovieticketapp.Repositories.SeatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SeatService implements ISeatService{
    private final RoomRepository roomRepository;
    private final SeatRepository seatRepository;

    @Override
    public Seat createSeat(SeatDTO seatDTO) throws Exception {
        Room existingRoom = roomRepository.findById(seatDTO.getRoomid())
                .orElseThrow(()-> new RuntimeException("Khong tim thay RoomId"));

        Seat newSeat = Seat
                .builder()
                .room(existingRoom)
                .seatnumber(seatDTO.getSeatnumber())
                .build();
        seatRepository.save(newSeat);
        return newSeat;
    }

    @Override
    public Seat getSeatById(int id) throws Exception {
        return seatRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Khong tim thay SeatId"));
    }

    @Override
    public Seat updateSeat(int id, SeatDTO seatDTO) throws Exception {
        Seat existingSeat = seatRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Khong tim thay SeatId"));

        Room existingRoom = roomRepository.findById(seatDTO.getRoomid())
                .orElseThrow(()-> new RuntimeException("Khong tim thay RoomId"));

        existingSeat.setRoom(existingRoom);
        existingSeat.setSeatnumber(seatDTO.getSeatnumber());
        seatRepository.save(existingSeat);
        return existingSeat;
    }

    @Override
    public List<Seat> getSeatByRoomId(int roomId) throws Exception {
        Room existingRoom = roomRepository.findById(roomId)
                .orElseThrow(()-> new RuntimeException("Khong tim thay RoomId"));

        return seatRepository.findByRoomId(existingRoom);
    }
}
