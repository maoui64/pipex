#################### SETUP ####################

CC			= cc
CFLAGS		= -Wall -Werror -Wextra -g
NAME		= pipex
NOPRINT		= --no-print-directory

#################### PATH ####################

SRC_PATH	= src/
OBJ_PATH	= obj/
SRC_PATH_BONUS	= src/
OBJ_PATH_BONUS	= obj_bonus/
INCLD		= -Iincludes
LIBFT		= libft/libft.a

#################### SRC & OBJ ####################

SRC			= pipex.c utils.c cmd.c files.c
SRCS		= $(addprefix $(SRC_PATH), $(SRC))
MAIN		= src/pipex.c

OBJ			= $(SRC:.c=.o)
OBJS		= $(addprefix $(OBJ_PATH), $(OBJ))

SRC_BONUS		= pipex_bonus.c utils.c cmd.c files.c gnl.c
SRCS_BONUS		= $(addprefix $(SRC_PATH_BONUS), $(SRC_BONUS))
MAIN_BONUS		= src/pipex_bonus.c

OBJ_BONUS		= $(SRC_BONUS:.c=.o)
OBJS_BONUS		= $(addprefix $(OBJ_PATH_BONUS), $(OBJ_BONUS))


#################### RULES ####################

all : $(OBJ_PATH) $(NAME)

clean:
	@make clean $(NOPRINT) -C ./libft
	@rm -rf $(OBJ_PATH)
	@rm -rf $(OBJ_PATH_BONUS)
	@echo "\033[1;30m----------- PIPEX'S OBJ CLEANED-----------\033[0;29m"

fclean: clean
	@make fclean $(NOPRINT) -C ./libft
	@rm -f $(NAME)
	@echo "\033[1;30m----------- PIPEX CLEANED-----------\033[0;29m"
	
re: fclean all

rebonus: fclean bonus

clibft:
	@echo "\033[1;36m----------- COMPILING LIBFT -----------\033[0;29m"
	@make $(NOPRINT) -C ./libft
	@echo "\033[1;36m----------- LIBFT COMPILED -----------\033[0;29m"


#################### COMPILATION ####################

# MANDATORY
$(OBJ_PATH)%.o : $(SRC_PATH)%.c
	@$(CC) $(CFLAGS) $(INCLD) -c $< -o $@

$(OBJ_PATH) :
	@mkdir $(OBJ_PATH)

$(NAME) : $(OBJS)
	@echo "\033[1;32m----------- COMPILING PIPEX -----------\033[0;29m"
	@make $(NOPRINT) clibft
	@$(CC) $(CFLAGS) $(OBJS) $(LIBFT) -o $(NAME)
	@echo "\033[1;32m----------- PIPEX COMPILED -----------\033[0;29m"

# BONUS
$(OBJ_PATH_BONUS)%.o : $(SRC_PATH_BONUS)%.c
	@$(CC) $(CFLAGS) $(INCLD) -c $< -o $@

$(OBJ_PATH_BONUS) :
	@mkdir $(OBJ_PATH_BONUS)

bonus : $(OBJ_PATH_BONUS) $(OBJS_BONUS)
	@echo "\033[1;32m----------- COMPILING BONUS PIPEX -----------\033[0;31m"
	@make $(NOPRINT) clibft
	@$(CC) $(CFLAGS) $(OBJS_BONUS) $(LIBFT) -o $(NAME)
	@echo "\033[1;32m----------- BONUS PIPEX COMPILED -----------\033[0;29m"

#################### HELP ####################

input:
		@echo "\n\033[1;35m----------- NORMAL INPUT TEST -----------\033[0;33m"
		@echo "./pipex Makefile cat \"grep PHONY\" outfile"
		@echo "is equivalent to:\n\t< Makefile cat | grep PHONY > outfile\n"
		@echo "\n\033[1;34m----------- VARIOUS TESTS -----------\033[0;33m"
		@echo "INFILE INCORRECT:\n./pipex Makefil cat \"grep PHONY\" outfile"
		@echo "is equivalent to:\n\t< Makefil cat | grep PHONY > outfile\n"
		@echo "CMD1 INCORRECT:\n./pipex Makefile nonexistent \"grep PHONY\" outfile"
		@echo "is equivalent to:\n\t< Makefile nonexistent | grep PHONY > outfile\n"
		@echo "CMD2 INCORRECT:\n./pipex Makefile cat nonexistent outfile"
		@echo "is equivalent to:\n\t< Makefile cat | nonexistent > outfile\n"
		@echo "TIME SLEEP:\ntime ./pipex Makefile \"sleep 2\" \"sleep 4\" outfile"
		@echo "is equivalent to:\n\ttime < Makefile sleep 2 | sleep 4 > outfile\n"
		@echo "\n\033[1;32m----------- VALGRIND TEST -----------\033[0;33m"
		@echo "Normal:\nvalgrind --leak-check=full ./pipex Makefile cat \"grep PHONY\" outfile\n"
		@echo "Check leaks in child process:\nvalgrind --leak-check=full --trace-children=yes ./pipex Makefile cat \"grep PHONY\" outfile\n"
		@echo "Check open fd:\nvalgrind --track-fds=yes ./pipex Makefile cat \"grep PHONY\" outfile\n"
		@echo "\n\033[1;36m----------- BONUS INPUT TEST -----------\033[0;33m"
		@echo "Multiple pipes:\n./pipex Makefile cat \"grep echo\" \"grep PHONY\" outfile"
		@echo "is equivalent to:\n\t< Makefile cat | grep echo | grep PHONY > outfile\n"
		@echo "here_doc:\n./pipex here_doc stop \"grep Hello\" \"grep hello\" outfile"
		@echo "is equivalent to:\n\tgrep Hello << stop | grep hello >> outfile\n"

#################### TEST ####################

tclean:
	@rm -f result_shell* result_pipex* infile out*

init:
	$(file > infile,Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.)
	$(file >> infile,Lorem ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.)
	$(file >> infile,Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.)
	$(file >> infile,Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.)
	@echo "\n\033[1;30m----------- INFILE CREATED -----------"

test : init
		@echo "\n\033[1;31m----------- ERROR TEST: no input -----------\033[0;33m"
		./pipex infile
		./pipex infile "grep hello"
		./pipex infile "grep hello" "wc"
		./pipex infile "grep hello" outfile
		@echo "\n\033[1;35m----------- FIRST TEST -----------\033[0;33m"
		< infile grep Lorem | wc -w > result_shell01
		@echo "Test shell :" && cat result_shell01
		./pipex infile "grep Lorem" "wc -w" result_pipex01
		@echo "Test pipex : " && cat result_pipex01
		@echo "\n\033[1;36m----------- SECOND TEST -----------\033[0;33m"
		< infile ls -l | wc -w > result_shell02
		@echo "Test shell :" && cat result_shell02
		./pipex infile "ls -l" "wc -w" result_pipex02
		@echo "Test pipex : " && cat result_pipex02
		@echo "\n\033[1;34m----------- THIRD TEST -----------\033[0;33m"
		< infile ls -l | grep infile > result_shell03
		@echo "Test shell :" && cat result_shell03
		./pipex infile "ls -l" "grep infile" result_pipex03
		@echo "Test pipex : " && cat result_pipex03
		@echo "\n\033[1;37m----------- ERROR TEST: infile incorrect -----------\033[0;33m"
		< infil grep hello | wc > result_shell04
		@echo "Test shell :" && cat result_shell04
		./pipex infil "grep hello" "wc" result_pipex04
		@echo "Test pipex : " && cat result_pipex04
		@echo "\n\033[1;38m----------- ERROR TEST: cmd incorrect -----------\033[0;33m"
		< infile gre hello | wc > result_shell05
		@echo "Test shell :" && cat result_shell05
		./pipex infile "gre hello" "wc" result_pipex05
		@echo "Test pipex : " && cat result_pipex05
		@echo "\n\033[1;32m----------- ERROR TEST: infile protected -----------\033[0;33m"
		chmod 000 infile
		< infile grep Lorem | wc -w > result_shell06
		@echo "Test shell :" && cat result_shell06
		./pipex infile "grep Lorem" "wc -w" result_pipex06
		@echo "Test pipex : " && cat result_pipex06
		chmod 644 infile


tbonus : init
		@echo "\033[1;35m----------- FIRST TEST -----------\033[0;33m"
		< infile grep Lorem | grep ipsum | wc -w > result_shell07
		@echo "\033[33mTest shell :" && cat result_shell07
		./pipex infile "grep Lorem" "grep ipsum" "wc -w" result_pipex07
		@echo "Test pipex : " && cat result_pipex07
		@echo "\n\033[1;36m----------- SECOND TEST -----------\033[0;33m"
		< infile ls -l | grep total | cat -e > result_shell08
		@echo "\033[33mTest shell :" && cat result_shell08
		./pipex infile "ls -l" "grep total" "cat -e" result_pipex08
		@echo "Test pipex : " && cat result_pipex08
		@echo "\n\033[1;34m----------- THIRD TEST -----------\033[0;33m"
		< infile ls -l | grep magahat | grep infile > result_shell09
		@echo "\033[33mTest shell :" && cat result_shell09
		./pipex infile "ls -l" "grep magahat" "grep infile" result_pipex09
		@echo "Test pipex : " && cat result_pipex09

.PHONY: all bonus clean fclean re rebonus tclean test tbonus input init