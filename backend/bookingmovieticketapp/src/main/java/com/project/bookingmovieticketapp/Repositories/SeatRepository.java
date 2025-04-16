package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Room;
import com.project.bookingmovieticketapp.Models.Seat;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SeatRepository extends JpaRepository<Seat,Integer> {
    List<Seat> findByRoomId(Room roomId);
}
