package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "movies")
@Builder
public class Movie {
    @Id
    private int id;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;
    private int duration;

    @Column(name = "releasedate", nullable = false)
    private LocalDate releasedate;

    private String posterurl;
    private String bannerurl;
    private String agerating;

    @Column(name = "voteaverage", nullable = false)
    private Double voteaverage;

    private String director;
}
