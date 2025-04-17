package com.project.bookingmovieticketapp.Services.Room;

import com.project.bookingmovieticketapp.DTOs.RoomDTO;
import com.project.bookingmovieticketapp.Models.Cinema;
import com.project.bookingmovieticketapp.Models.Room;
import com.project.bookingmovieticketapp.Repositories.CinemaRepository;
import com.project.bookingmovieticketapp.Repositories.RoomRepository;
import com.project.bookingmovieticketapp.Repositories.SeatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.EmptyStackException;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RoomService implements IRoomService {
    private final CinemaRepository cinemaRepository;
    private final RoomRepository roomRepositor;
    @Override
    public Room createRoom(RoomDTO roomDTO) {
        Cinema existingCinema = cinemaRepository.findById(roomDTO.getCinemaid())
                .orElseThrow(()->new RuntimeException("Khong tim thay CinemaId"));

        Room newRoom = Room
                .builder()
                .cinema(existingCinema)
                .name(roomDTO.getName())
                .seatcolumnmax(roomDTO.getSeatcolumnmax())
                .seatrowmax(roomDTO.getSeatrowmax())
                .build();
        roomRepositor.save(newRoom);
        return newRoom;
    }

    @Override
    public Room getRoomById(int id) throws Exception {
        return roomRepositor.findById(id)
                .orElseThrow(()-> new RuntimeException("Khong tim thay RoomId"));
    }

    @Override
    public Room updateRoom(int id, RoomDTO roomDTO) throws Exception {
        Room existingRoom = roomRepositor.findById(id)
                .orElseThrow(()-> new RuntimeException("Khong tim thay RoomId"));

        Cinema existingCinema = cinemaRepository.findById(roomDTO.getCinemaid())
                .orElseThrow(()->new RuntimeException("Khong tim thay CinemaId"));

        existingRoom.setCinema(existingCinema);
        existingRoom.setName(roomDTO.getName());
        existingRoom.setSeatrowmax(roomDTO.getSeatrowmax());
        existingRoom.setSeatcolumnmax(roomDTO.getSeatcolumnmax());

        roomRepositor.save(existingRoom);
        return existingRoom;
    }

    @Override
    public List<Room> getRoomByCinemaId(int cinemaId) throws Exception {
        Cinema existingCinema = cinemaRepository.findById(cinemaId)
                .orElseThrow(()-> new RuntimeException("Khong tim thay CinemaId"));
        return roomRepositor.findByCinemaId(existingCinema);
    }
}
