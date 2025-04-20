package com.project.bookingmovieticketapp.Services.Room;

import com.project.bookingmovieticketapp.DTOs.RoomDTO;
import com.project.bookingmovieticketapp.Models.Room;
import com.project.bookingmovieticketapp.Responses.RoomResponse;

import java.util.List;

public interface IRoomService {
    Room createRoom(RoomDTO roomDTO);
    RoomResponse getRoomById(int id) throws Exception;
    Room updateRoom(int id, RoomDTO roomDTO) throws Exception;
    List<RoomResponse> getRoomByCinemaId(int cinemaId) throws Exception;
}
