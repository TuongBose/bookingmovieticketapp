package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "casts")
@Builder
public class Cast {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "movieid")
    private Movie movie;

    @Column(name = "actorname",nullable = false)
    private String actorname;
}
