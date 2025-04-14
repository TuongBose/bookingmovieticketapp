package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "movies")
@Builder
public class Movie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "name", nullable = false)
    private String name;

    private String description;
    private int duration;

    @Column(name = "releasedate", nullable = false)
    private Date releasedate;

    private String posterurl;
    private String bannerurl;
    private String agerating;

    @Column(name = "voteaverage", nullable = false)
    private float voteaverage;

    private String director;
}
