package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "movienews")
@Builder
public class MovieNews {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "title",nullable = false)
    private String title;

    private String imageurl;

    @Column(name = "type",nullable = false)
    private String type;

    private Date publishdate;
    private String content;

    @ManyToOne
    @JoinColumn(name = "movieid")
    private Movie movie;
}
