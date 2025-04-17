package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Movie;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.*;
import java.time.LocalDate;

public interface MovieRepository extends JpaRepository<Movie,Integer> {
    List<Movie> findByReleasedateBetween(LocalDate start, LocalDate end);
    boolean existsByName(String name);
    Page<Movie> findAll(Pageable pageable);
    List<Movie> findByIdIn(List<Integer> ids);
}
