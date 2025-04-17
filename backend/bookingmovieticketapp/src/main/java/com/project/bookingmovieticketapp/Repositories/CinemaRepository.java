package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Cinema;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CinemaRepository extends JpaRepository<Cinema,Integer> {
    List<Cinema> findByCity (String city);

}
