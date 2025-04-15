package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Movie;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MovieRepository extends JpaRepository<Movie,Integer> {
    boolean existsByName(String name);
    Page<Movie> findAll(Pageable pageable);
}
