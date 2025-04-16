package com.project.bookingmovieticketapp.Services.Room;

import com.project.bookingmovieticketapp.DTOs.RoomDTO;
import com.project.bookingmovieticketapp.Models.Room;

import java.util.List;

public class RoomService implements IRoomService {
    @Override
    public Room createRoom(RoomDTO roomDTO) {
        return null;
    }

    @Override
    public Room getRoomById(int id) throws Exception {
        return null;
    }

    @Override
    public Room updateRoom(int id, RoomDTO roomDTO) throws Exception {
        return null;
    }

    @Override
    public List<Room> getRoomByCinemaId(int cinemaId) throws Exception {
        return List.of();
    }
}
