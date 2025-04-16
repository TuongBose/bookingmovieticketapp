package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.ShowTime;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ShowTimeRepository extends JpaRepository<ShowTime,Integer> {
}
