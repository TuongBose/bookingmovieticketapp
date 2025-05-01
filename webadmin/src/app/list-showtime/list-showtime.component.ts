import { Component } from '@angular/core';
import { OnInit } from '@angular/core';
import { ShowtimeDTO } from '../dtos/showtime.dto';
import { ShowTimeService } from '../services/showtime.service';
import { CinemaDTO } from '../dtos/cinema.dto';
import { CinemaService } from '../services/cinema.service';
import { MovieDTO } from '../dtos/movie.dto';
import { MovieService } from '../services/movie.service';

@Component({
  selector: 'app-list-showtime',
  standalone: false,
  templateUrl: './list-showtime.component.html',
  styleUrl: './list-showtime.component.css'
})
export class ListShowtimeComponent implements OnInit {
  showtimes: ShowtimeDTO[] = [];
    showtimesByMovie: { movieId: number, movieName: string, showtimes: ShowtimeDTO[] }[] = [];
    cinemas: CinemaDTO[] = [];
    movies: MovieDTO[] = [];
    selectedCinemaId: number | null = null;
    selectedDate: string | null = null;
    selectedMovieId: number | null = null;
    showOnlyActive: boolean = false;
    errorMessage: string | null = null;
    successMessage: string | null = null;
    isLoading: boolean = false;
    bookingsCountMap: Map<number, number> = new Map(); // Lưu số lượng vé đã đặt

    constructor(
        private showTimeService: ShowTimeService,
        private cinemaService: CinemaService,
        private movieService: MovieService
    ) { }

    ngOnInit(): void {
        this.loadCinemas();
        this.loadMovies();
    }

    loadCinemas(): void {
        this.cinemaService.getAllCinema().subscribe({
            next: (cinemas) => {
                this.cinemas = cinemas;
            },
            error: (error) => {
                this.errorMessage = 'Không thể tải danh sách rạp: ' + error.message;
            }
        });
    }

    loadMovies(): void {
        // Kết hợp phim đang chiếu và sắp chiếu
        this.movieService.getAllMovie().subscribe({
            next: (nowPlaying) => {
                this.movies = nowPlaying;
                this.movieService.getMovieUpComing().subscribe({
                    next: (upcoming) => {
                        this.movies = [...this.movies, ...upcoming];
                    },
                    error: (error) => {
                        this.errorMessage = 'Không thể tải danh sách phim sắp chiếu: ' + error.message;
                    }
                });
            },
            error: (error) => {
                this.errorMessage = 'Không thể tải danh sách phim đang chiếu: ' + error.message;
            }
        });
    }

    fetchShowtimes(): void {
        if (!this.selectedCinemaId || !this.selectedDate) {
            this.errorMessage = 'Vui lòng chọn rạp và ngày.';
            return;
        }

        this.isLoading = true;
        this.errorMessage = null;

        this.showTimeService.getShowTimesByCinemaIdAndDate(this.selectedCinemaId, this.selectedDate)
            .subscribe({
                next: (showtimes) => {
                    this.showtimes = showtimes;
                    this.loadBookingsCount();
                    this.filterAndGroupShowtimes();
                    this.isLoading = false;
                },
                error: (error) => {
                    this.errorMessage = error.message;
                    this.showtimes = [];
                    this.showtimesByMovie = [];
                    this.bookingsCountMap.clear();
                    this.isLoading = false;
                }
            });
    }

    loadBookingsCount(): void {
        this.bookingsCountMap.clear();
        this.showtimes.forEach(showtime => {
            this.showTimeService.getBookingsCountForShowTime(showtime.id).subscribe({
                next: (count) => {
                    this.bookingsCountMap.set(showtime.id, count);
                },
                error: (error) => {
                    console.error(`Không thể lấy số lượng vé cho suất chiếu ${showtime.id}:`, error);
                }
            });
        });
    }

    filterAndGroupShowtimes(): void {
        let filteredShowtimes = [...this.showtimes];

        if (this.showOnlyActive) {
            filteredShowtimes = filteredShowtimes.filter(showtime => showtime.isactive);
        }

        if (this.selectedMovieId) {
            filteredShowtimes = filteredShowtimes.filter(showtime => showtime.movieId === this.selectedMovieId);
        }

        const groupedShowtimes = new Map<number, ShowtimeDTO[]>();
        filteredShowtimes.forEach(showtime => {
            if (!groupedShowtimes.has(showtime.movieId)) {
                groupedShowtimes.set(showtime.movieId, []);
            }
            groupedShowtimes.get(showtime.movieId)!.push(showtime);
        });

        this.showtimesByMovie = Array.from(groupedShowtimes.entries())
            .map(([movieId, showtimes]) => ({
                movieId,
                movieName: this.movies.find(movie => movie.id === movieId)?.name || `Phim ${movieId}`,
                showtimes: showtimes.sort((a, b) => new Date(a.starttime).getTime() - new Date(b.starttime).getTime())
            }))
            .sort((a, b) => a.movieName.localeCompare(b.movieName));
    }

    resetFilters(): void {
        this.selectedCinemaId = null;
        this.selectedDate = null;
        this.selectedMovieId = null;
        this.showOnlyActive = false;
        this.showtimes = [];
        this.showtimesByMovie = [];
        this.bookingsCountMap.clear();
        this.errorMessage = null;
    }

    viewDetails(showtimeId: number): void {
        this.showTimeService.getShowTimeById(showtimeId).subscribe({
            next: (showtime) => {
                alert(`Chi tiết suất chiếu #${showtime.id}: Movie ID: ${showtime.movieId}, Room ID: ${showtime.roomId}, Ngày: ${showtime.showdate}, Giờ: ${showtime.starttime}`);
            },
            error: (error) => {
                this.errorMessage = 'Không thể lấy chi tiết suất chiếu: ' + error.message;
            }
        });
    }

    toggleShowtimeStatus(showtimeId: number, currentStatus: boolean): void {
      this.errorMessage = null;
      this.successMessage = null;
      this.showTimeService.updateShowTimeStatus(showtimeId, !currentStatus).subscribe({
          next: (response) => {
              this.successMessage = response.message; // Hiển thị thông báo thành công
              this.fetchShowtimes(); // Tải lại danh sách để cập nhật giao diện
          },
          error: (error) => {
              this.errorMessage = 'Không thể cập nhật trạng thái suất chiếu: ' + error.message;
          }
      });
  }
}
