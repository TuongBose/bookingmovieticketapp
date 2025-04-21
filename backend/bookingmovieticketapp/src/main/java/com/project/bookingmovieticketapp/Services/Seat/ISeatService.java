package com.project.bookingmovieticketapp.Services.Seat;

import com.project.bookingmovieticketapp.DTOs.SeatDTO;
import com.project.bookingmovieticketapp.Models.Seat;
import com.project.bookingmovieticketapp.Responses.SeatResponse;

import java.util.List;

public interface ISeatService {
    Seat createSeat(SeatDTO seatDTO) throws Exception;
    Seat getSeatById(int id) throws Exception;
    Seat updateSeat(int id, SeatDTO seatDTO) throws Exception;
    List<SeatResponse> getSeatByRoomId(int roomId) throws Exception;
}
