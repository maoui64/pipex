#################### SETUP ####################

CC			= cc
CFLAGS		= -Wall -Werror -Wextra
NAME		= pipex

#################### PATH ####################

SRC_PATH	= src/
OBJ_PATH	= obj/
SRC_PATH_BONUS	= src/
OBJ_PATH_BONUS	= obj_bonus/
INCLD		= -Iincludes

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
	@echo "\033[1;30m----------- CLEANING PIPEX OBJ -----------\033[0;29m"
	@make clean -C ./libft
	@rm -rf $(OBJ_PATH)
	@rm -rf $(OBJ_PATH_BONUS)
	@echo "\033[1;30m----------- PIPEX OBJ CLEANED-----------\033[0;29m"

fclean: clean
	@echo "\033[1;30m----------- CLEANING PIPEX -----------\033[0;29m"
	@make fclean -C ./libft
	@rm -f $(NAME)
	@echo "\033[1;30m----------- PIPEX CLEANED-----------\033[0;29m"
	
re: fclean all

rebonus: fclean bonus

#################### COMPILATION ####################

# MANDATORY
$(OBJ_PATH)%.o : $(SRC_PATH)%.c
	@$(CC) $(CFLAGS) $(INCLD) -c $< -o $@

$(OBJ_PATH) :
	@mkdir $(OBJ_PATH)

$(NAME) : $(OBJS)
	@echo "\033[1;30m----------- COMPILING PIPEX -----------\033[0;29m"
	@rm -f $(NAME)
	@rm -rf $(OBJ_PATH_BONUS)
	@make -C ./libft
	@$(CC) $(CFLAGS) $(OBJS) -Llibft -lft -o $(NAME)
	@echo "\033[1;30m----------- PIPEX COMPILED -----------\033[0;29m"

# BONUS
$(OBJ_PATH_BONUS)%.o : $(SRC_PATH_BONUS)%.c
	@$(CC) $(CFLAGS) $(INCLD) -c $< -o $@

$(OBJ_PATH_BONUS) :
	@mkdir $(OBJ_PATH_BONUS)

bonus : $(OBJ_PATH_BONUS) $(OBJS_BONUS)
	@echo "\033[1;30m----------- COMPILING PIPEX -----------\033[0;29m"
	@rm -f $(NAME)
	@rm -rf $(OBJ_PATH)
	@make -C ./libft
	@$(CC) $(CFLAGS) $(OBJS_BONUS) -Llibft -lft -o $(NAME)
	@echo "\033[1;30m----------- PIPEX COMPILED -----------\033[0;29m"

#################### TEST ####################

tclean:
	@rm -f result_shell* result_pipex* infile

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


tbonus :
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
		@echo "\n\033[1;37m----------- HERE_DOC: 2 cmd -----------\033[0;33m"
		@echo "\ngrep Hello << stop | wc -w >> result_shell10\n"
		@echo "\n./pipex here_doc stop \"grep Hello\" \"wc -c\" result_pipex10\n"
		@echo "\n\033[1;32m----------- HERE_DOC: 3 cmd -----------\033[0;33m"
		@echo "\ngrep Hello << stop | grep hello | wc -w >> result_shell10\n"
		@echo "\n./pipex here_doc stop \"grep Hello\" \"grep hello\" \"wc -w\" outfile"

input:
		@echo "\n\033[1;35m----------- NORMAL INPUT TEST -----------\033[0;33m"
		@echo "./pipex infile cmd1 cmd2 outfile"
		@echo "is equivalent to:\n\t< infile cmd1 | cmd2 > outfile\n"
		@echo "\n\033[1;32m----------- VALGRIND TEST -----------\033[0;33m"
		@echo "Normal:\nvalgrind --leak-check=full ./pipex infile cmd1 cmd2 outfile\n"
		@echo "Check leaks in child process:\nvalgrind --leak-check=full --trace-children=yes ./pipex infile cmd1 cmd2 outfile\n"
		@echo "Check open fd:\nvalgrind --track-fds=yes ./pipex infile cmd1 cmd2 outfile\n"
		@echo "\n\033[1;36m----------- BONUS INPUT TEST -----------\033[0;33m"
		@echo "Multiple pipes:\n./pipex infile cmd1 cmd2 cmd3 outfile"
		@echo "is equivalent to:\n\t< infile cmd1 | cmd2 | cmd3 > outfile\n"
		@echo "here_doc:\n./pipex here_doc LIMITER cm1 cmd2 outfile"
		@echo "is equivalent to:\n\tcmd1 << LIMITER | cmd2 >> outfile\n"

.PHONY: all bonus clean fclean re rebonus tclean test tbonus input