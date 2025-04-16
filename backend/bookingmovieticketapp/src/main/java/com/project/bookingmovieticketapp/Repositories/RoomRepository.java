package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Cinema;
import com.project.bookingmovieticketapp.Models.Room;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RoomRepository extends JpaRepository<Room,Integer> {
    List<Room> findByCinemaId(Cinema cinema);
}
