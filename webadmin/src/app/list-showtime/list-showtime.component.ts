import { Component, OnInit } from '@angular/core';
import { ShowtimeDTO } from '../dtos/showtime.dto';
import { ShowTimeService } from '../services/showtime.service';
import { CinemaDTO } from '../dtos/cinema.dto';
import { CinemaService } from '../services/cinema.service';
import { MovieDTO } from '../dtos/movie.dto';
import { MovieService } from '../services/movie.service';
import { MatDialog } from '@angular/material/dialog';
import { ShowtimeDetailDialogComponent } from './showtime-detail-dialog.component';

@Component({
    selector: 'app-list-showtime',
    standalone: false,
    templateUrl: './list-showtime.component.html',
    styleUrls: ['./list-showtime.component.css']
})
export class ListShowtimeComponent implements OnInit {
    showtimes: ShowtimeDTO[] = [];
    showtimesByMovie: { movieId: number, movieName: string, showtimes: ShowtimeDTO[], posterURL: string }[] = [];
    cinemas: CinemaDTO[] = [];
    movies: MovieDTO[] = [];
    selectedCinemaId: number | null = null;
    selectedDate: string | null = null;
    selectedMovieId: number | null = null;
    showOnlyActive: boolean = false;
    errorMessage: string | null = null;
    successMessage: string | null = null;
    isLoading: boolean = false;
    bookingsCountMap: Map<number, number> = new Map();

    constructor(
        private showTimeService: ShowTimeService,
        private cinemaService: CinemaService,
        private movieService: MovieService,
        private dialog: MatDialog
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
                console.error('[loadCinemas] Lỗi khi lấy danh sách rạp:', error);
            }
        });
    }

    loadMovies(): void {
        this.movieService.getAllMovie().subscribe({
            next: (nowPlaying) => {
                this.movies = nowPlaying;
                this.movieService.getMovieUpComing().subscribe({
                    next: (upcoming) => {
                        this.movies = [...this.movies, ...upcoming];
                        if (this.showtimes.length > 0) {
                            this.filterAndGroupShowtimes();
                        }
                    },
                    error: (error) => {
                        this.errorMessage = 'Không thể tải danh sách phim sắp chiếu: ' + error.message;
                        console.error('[loadMovies] Lỗi khi lấy danh sách phim sắp chiếu:', error);
                    }
                });
            },
            error: (error) => {
                this.errorMessage = 'Không thể tải danh sách phim đang chiếu: ' + error.message;
                console.error('[loadMovies] Lỗi khi lấy danh sách phim đang chiếu:', error);
            }
        });
    }

    fetchShowtimes(): void {
        if (!this.selectedCinemaId || !this.selectedDate) {
            this.errorMessage = 'Vui lòng chọn rạp và ngày.';
            console.warn('[fetchShowtimes] Thiếu rạp hoặc ngày:', {
                selectedCinemaId: this.selectedCinemaId,
                selectedDate: this.selectedDate
            });
            return;
        }

        this.isLoading = true;
        this.errorMessage = null;
        this.successMessage = null;

        this.showTimeService.getShowTimesByCinemaIdAndDate(this.selectedCinemaId, this.selectedDate)
            .subscribe({
                next: (showtimes) => {
                    this.showtimes = showtimes;
                    this.validateShowtimes();
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
                    console.error('[fetchShowtimes] Lỗi khi lấy danh sách suất chiếu:', error);
                }
            });
    }

    validateShowtimes(): void {
        const movieIdsInShowtimes = new Set(this.showtimes.map(showtime => showtime.movieId));
        const movieIdsInMovies = new Set(this.movies.map(movie => movie.id));
        const unmatchedMovieIds = [...movieIdsInShowtimes].filter(id => !movieIdsInMovies.has(id));
        if (unmatchedMovieIds.length > 0) {
            console.warn(`[validateShowtimes] Có suất chiếu với movieId không khớp với danh sách phim: ${unmatchedMovieIds.join(', ')}`);
            this.errorMessage = 'Một số suất chiếu không tìm thấy thông tin phim tương ứng.';
        }
    }

    loadBookingsCount(): void {
        this.bookingsCountMap.clear();
        this.showtimes.forEach(showtime => {
            this.showTimeService.getBookingsCountForShowTime(showtime.id).subscribe({
                next: (count) => {
                    this.bookingsCountMap.set(showtime.id, count);
                },
                error: (error) => {
                    console.error(`[loadBookingsCount] Lỗi khi lấy số lượng vé cho suất chiếu ${showtime.id}:`, error);
                }
            });
        });
    }

    filterAndGroupShowtimes(): void {
        // Nếu không có dữ liệu suất chiếu, không cần xử lý tiếp
        if (!this.showtimes || this.showtimes.length === 0) {
            this.showtimesByMovie = [];
            return;
        }

        let filteredShowtimes = [...this.showtimes];

        // Xóa thông báo lỗi trước khi lọc
        this.errorMessage = null;

        // Lọc theo trạng thái hoạt động
        if (this.showOnlyActive) {
            filteredShowtimes = filteredShowtimes.filter(showtime => showtime.isactive);
        }

        // Lọc theo phim
        if (this.selectedMovieId !== null && this.selectedMovieId !== undefined) {
            filteredShowtimes = filteredShowtimes.filter(showtime => showtime.movieId === this.selectedMovieId);
        }

        // Nhóm suất chiếu theo phim
        const groupedShowtimes = new Map<number, ShowtimeDTO[]>();
        filteredShowtimes.forEach(showtime => {
            if (!groupedShowtimes.has(showtime.movieId)) {
                groupedShowtimes.set(showtime.movieId, []);
            }
            groupedShowtimes.get(showtime.movieId)!.push(showtime);
        });

        this.showtimesByMovie = Array.from(groupedShowtimes.entries())
            .map(([movieId, showtimes]) => {
                const movie = this.movies.find(m => m.id === movieId);
                if (!movie) {
                    console.warn(`[filterAndGroupShowtimes] Không tìm thấy phim với movieId: ${movieId}`);
                }
                return {
                    movieId,
                    movieName: movie?.name || `Phim ${movieId}`,
                    posterURL: movie?.posterurl || 'https://via.placeholder.com/100x150?text=No+Image',
                    showtimes: showtimes.sort((a, b) => new Date(a.starttime).getTime() - new Date(b.starttime).getTime())
                };
            })
            .sort((a, b) => a.movieName.localeCompare(b.movieName));

        // Hiển thị thông báo nếu không có suất chiếu sau khi lọc
        if (this.showtimes.length > 0 && this.showtimesByMovie.length === 0 && (this.selectedMovieId !== null || this.showOnlyActive)) {
            this.errorMessage = 'Không có suất chiếu nào khớp với bộ lọc của bạn.';
        }
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
        this.successMessage = null;
    }

    viewDetails(showtimeId: number): void {
        this.showTimeService.getShowTimeById(showtimeId).subscribe({
            next: (showtime) => {
                this.dialog.open(ShowtimeDetailDialogComponent, {
                    width: '400px',
                    data: showtime
                });
            },
            error: (error) => {
                this.errorMessage = 'Không thể lấy chi tiết suất chiếu: ' + error.message;
                console.error(`[viewDetails] Lỗi khi lấy chi tiết suất chiếu ${showtimeId}:`, error);
            }
        });
    }

    toggleShowtimeStatus(showtimeId: number, currentStatus: boolean): void {
        this.errorMessage = null;
        this.successMessage = null;
        this.showTimeService.updateShowTimeStatus(showtimeId, !currentStatus).subscribe({
            next: (response) => {
                this.successMessage = response.message;
                this.fetchShowtimes();
            },
            error: (error) => {
                this.errorMessage = 'Không thể cập nhật trạng thái suất chiếu: ' + error.message;
                console.error(`[toggleShowtimeStatus] Lỗi khi cập nhật trạng thái suất chiếu ${showtimeId}:`, error);
            }
        });
    }
}