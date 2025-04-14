package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "ratings")
@Builder
public class Rating {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "movieid")
    private Movie movie;

    @ManyToOne
    @JoinColumn(name ="userid")
    private User user;

    @Column(name = "rating",nullable = false)
    private int rating;

    private String comment;
    private LocalDateTime createdat;

    @PrePersist
    protected void onCreate() {
        createdat = LocalDateTime.now();
    }
}
