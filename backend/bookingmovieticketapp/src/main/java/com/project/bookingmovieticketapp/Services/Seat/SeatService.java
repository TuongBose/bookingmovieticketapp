package com.project.bookingmovieticketapp.Services.Seat;

import com.project.bookingmovieticketapp.DTOs.SeatDTO;
import com.project.bookingmovieticketapp.Models.Seat;

import java.util.List;

public class SeatService implements ISeatService{
    @Override
    public Seat createSeat(SeatDTO seatDTO) throws Exception {
        return null;
    }

    @Override
    public Seat getSeatById(int id) throws Exception {
        return null;
    }

    @Override
    public Seat updateSeat(int id, SeatDTO seatDTO) throws Exception {
        return null;
    }

    @Override
    public List<Seat> getSeatByRoomId(int roomId) throws Exception {
        return List.of();
    }
}
