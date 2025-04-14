package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "showtimes")
@Builder
public class ShowTime {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "movieid")
    private Movie movie;

    @ManyToOne
    @JoinColumn(name = "roomid")
    private Room room;

    @Column(name = "showdate",nullable = false)
    private Date showdate;

    @Column(name = "starttime",nullable = false)
    private LocalDateTime starttime;

    @Column(name = "price",nullable = false)
    private int price;
}
