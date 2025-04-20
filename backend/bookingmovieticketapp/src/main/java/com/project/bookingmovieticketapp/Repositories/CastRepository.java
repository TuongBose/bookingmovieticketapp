package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Cast;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CastRepository extends JpaRepository<Cast,Integer> {
    List<Cast> findByMovieId(int movieId);
}
