package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Cinema;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CinemaRepository extends JpaRepository<Cinema,Integer> {
}
